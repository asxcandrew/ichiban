class Post < ActiveRecord::Base
  include Tripcode
  include ColorDigest
  attr_accessible(:name,
                  :subject,
                  :body,
                  :tripcode,
                  :directory,
                  :parent_id,
                  :ancestor_id,
                  :image_attributes)

  belongs_to :board, foreign_key: 'directory', primary_key: 'directory'
  belongs_to :parent, class_name: 'Post'
  belongs_to :ancestor, class_name: 'Post'

  # OPTIMIZE: I'm concerned about the time it takes to delete each child.
  has_many :children, class_name: 'Post', :foreign_key => :parent_id, :dependent => :destroy
  has_many :reports, :dependent => :destroy

  has_one :image, :dependent => :destroy
  accepts_nested_attributes_for :image

  before_save :parse_name
  after_save :touch_ancestor
  validates_presence_of :directory
  validates_presence_of :parent, 
                        :if => :parent_required?, 
                        message: "Parent post not found. Was it deleted?"

  validates_presence_of :image, 
                        :if => :image_required?, 
                        message: "An image is required when starting a thread or if comment is not added."
  validate :upload_file_size
  validate :board_existance

  # Maximum length is also limited 
  # in the post.js.coffeescript.
  validates_length_of :body, maximum: 800

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

    # An image is required if the post is a parent 
    # or if the body is blank.
    def image_required?
      if self.parent_id # post is a reply
        return self.body.blank?
      else 
        return true
      end
    end

    def parse_name
      # self.name will be nil if we're just 
      # instantiating objects via Rake.
      input = self.name || ''

      hash_pos = input.index('#')

      if hash_pos
        name = hash_pos == 0 ? 'Anonymous' : input[0...hash_pos]
        
        # Everything after the hash.
        password = input[ ((hash_pos + 1)..-1) ]

        self.tripcode = crypt_tripcode(password)
        self.color = input_to_color(self.tripcode)

        self.name = name
      else
        self.name = input.blank? ? "Anonymous" : input
        self.color = input_to_color(self.ip_address)
      end
    end
  #end_private

end