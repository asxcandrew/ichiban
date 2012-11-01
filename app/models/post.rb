class Post < ActiveRecord::Base
  include ColorDigest
  include LoremIpsum
  include Tripcode
  attr_accessible(:ip_address,
                  :subject,
                  :body,
                  :directory,
                  :parent_id,
                  :ancestor_id,
                  :image_attributes,
                  :tripcode,
                  :secure_tripcode,
                  :name)

  # Board relations
  belongs_to :board, foreign_key: 'directory', primary_key: 'directory'
  validate :board_existance
  validates_presence_of :directory

  # Lineage
  # OPTIMIZE: I'm concerned about the time it takes to delete each child.
  belongs_to :parent, class_name: 'Post'
  validates_presence_of :parent, 
                        :if => :parent_required?, 
                        message: "Parent post not found. Was it deleted?"

  belongs_to :ancestor, class_name: 'Post'
  has_many :children, class_name: 'Post', :foreign_key => :parent_id, :dependent => :destroy
  has_many :descendants, class_name: 'Post', :foreign_key => :ancestor_id, :primary_key => :id

  # Assets
  has_one :image, :dependent => :destroy
  accepts_nested_attributes_for :image
  validate :upload_file_size
  validates_presence_of :image, 
                        :if => :image_required?, 
                        message: "An image is required when starting a thread or if comment is not added."

  # Attributes
  validates_length_of :name, maximum: 64, message: "Names must be shorter than 65 characters."
  validates_length_of :subject, maximum: 64, message: "Subject must be shorter than 65 characters."

  # Suspensions
  has_many :suspensions, conditions: ["ends_at > ?", Date.today]
  validate :active_suspensions
  
  # Reports
  has_many :reports, :dependent => :destroy

  # Routines
  before_save :add_lorem_ipsum, :if => :new_record?
  before_save :calculate_color, :if => :new_record?
  after_validation :touch_ancestor
  after_validation :increment_parent_replies!

  after_initialize :init
  after_destroy :decrement_parent_replies!


  # Maximum length is also limited 
  # in the post.js.coffee file.
  validates_length_of :body, maximum: 800

  # We only increment after_validation instead of after_save to avoid undoing
  # the decrement method.
  def increment_parent_replies!
    if self.parent
      self.parent.with_lock do
        self.parent.increment!(:replies)
        self.parent.increment_parent_replies!
      end
    end
  end

  def decrement_parent_replies!
    if self.parent
      self.parent.with_lock do
        self.parent.decrement!(:replies)
        self.parent.decrement_parent_replies!
      end
    end
  end

  def name=(input = '')
    options = {}
    default_name = "Anonymous"
    # Check for tripcode
    hash_pos = input.index('#')
    
    # Check for secure tripcode
    double_hash_pos = input.index('##')

    options[:tripcode] = true if hash_pos && hash_pos != double_hash_pos
    options[:secure_tripcode] = true if double_hash_pos

    if options[:tripcode] || options[:secure_tripcode]
      self[:name] = hash_pos == 0 ? default_name : input[0...hash_pos]
    else
      self[:name] = input.blank? ? default_name : input
    end

    if options[:secure_tripcode]
      password = input[(double_hash_pos + 2)..-1]
      self.secure_tripcode = generate_tripcode(password, secure: false)
  
      if options[:tripcode]
        password = input[(hash_pos + 1)...double_hash_pos]
        self.tripcode = generate_tripcode(password)
      end

    elsif options[:tripcode]
      password = input[(hash_pos + 1)..-1]
      self.tripcode = generate_tripcode(password)
    end
  end

  def date
    self.created_at.strftime("%Y-%m-%d %l:%M %p %Z")
  end

  def verify_tripcode(input)
    !input.blank? && self.tripcode == crypt_tripcode(input)
  end

  def is_ancestor?
    self.ancestor_id.nil?
  end

  private
    def init
      # Will set the default value only if it's nil
      self.replies ||= 0
    end

    def calculate_color
      self.color = input_to_color(self.tripcode || self.ip_address)
    end
    
    def touch_ancestor
      if self.ancestor
        self.ancestor.touch
      end
    end

    # Check the existance of a parent if a parent_id has been given.
    def parent_required?
      !!self.parent_id
    end

    def board_existance
      unless Board.find_by_directory(self.directory)
        errors.add(:board_existance, "The board specified does not exist.")
      end
    end

    def upload_file_size
    end

    def active_suspensions
      suspensions = Suspension.where("ip_address = ? AND ends_at > ?", self.ip_address, Date.today)

      if suspensions.any?
        suspensions.each do |suspension|
          errors.add(
            :suspended, 
            "Your posting privilages have been suspended until #{suspension.ends_at} for: #{suspension.reason}")
        end
      end
    end

    # An image is required if the post is a parent 
    # or if the body is blank.
    def image_required?
      if self.parent_id # post is a reply
        return self.body.blank?
      else 
        return true
      end
    end

    def add_lorem_ipsum
      if Rails.env.development? && self.body == "lorem"
        self.body = generate_lorem_ipsum
      end
    end
  #end_private
end