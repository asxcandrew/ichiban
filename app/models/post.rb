class Post < ActiveRecord::Base
  include ColorDigest
  include LoremIpsum
  attr_accessible(:ip_address,
                  :subject,
                  :body,
                  :directory,
                  :parent_id,
                  :ancestor_id,
                  :image_attributes,
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

  # Suspensions
  has_many :suspensions, conditions: ["ends_at > ?", Date.today]
  validate :active_suspensions
  
  # Reports
  has_many :reports, :dependent => :destroy

  # Tripcodes
  has_one :tripcode

  # Routines
  before_save :add_lorem_ipsum
  before_save :calculate_color
  after_save :touch_ancestor


  # Maximum length is also limited 
  # in the post.js.coffeescript.
  validates_length_of :body, maximum: 800

  def name=(input)
    # self.name will be nil if we're just 
    # instantiating objects via Rake.
    input = '' if input.nil?

    hash_pos = input.index('#')

    if hash_pos
      name = hash_pos == 0 ? 'Anonymous' : input[0...hash_pos]
      
      # Everything after the hash.
      password = input[ ((hash_pos + 1)..-1) ]
      self.tripcode = Tripcode.new
      self.tripcode.encryption = password

      self[:name] = name
    else
      self[:name] = input.blank? ? "Anonymous" : input
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
    def calculate_color
      self.color = input_to_color(self.tripcode ? self.tripcode.encryption : self.ip_address)
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