class Post < ActiveRecord::Base
  include Tripcode
  attr_accessible(:name,
                  :subject,
                  :body,
                  :tripcode,
                  :directory,
                  :parent_id,
                  :image)

  belongs_to :board
  belongs_to :parent, class_name: 'Post'
  has_many :children, class_name: 'Post', :foreign_key => :parent_id

  before_save :parse_name

  # Mounted by Carrierwave.
  # See documentation for more information.
  mount_uploader :image, ImageUploader

  # TODO: Validate existance of directory
  validates_presence_of :directory
  
  validates_presence_of(:body,
                        :if => :body_required?)

  validates_presence_of(:image, 
                        :if => :image_required?)


  validates :image, file_size: { maximum: (1.megabytes.to_i) }

  # Maximum length is also limited 
  # in the post.js.coffeescript.
  validates_length_of :body, maximum: 800

  # A body is required if an image is not given.
  def body_required?
    return !self.image?
  end

  # An image is required if the post is a parent 
  # or if the body is blank.
  def image_required?
    if self.parent # post is a reply
      return self.body.blank?
    else
      return true
    end
  end

  def date
    self.created_at.strftime("%Y-%m-%d %l:%M %p %Z")
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
      self.tripcode_hex = crypt_tripcode_hex(self.tripcode)

      self.name = name
    else
      self.name = input.blank? ? "Anonymous" : input
    end
  end

  def destroy(input)
    self.delete if (self.tripcode == crypt_tripcode(input))
  end

end