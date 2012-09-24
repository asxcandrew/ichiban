class Post < ActiveRecord::Base
  include Tripcode
  include ColorDigest
  attr_accessible(:name,
                  :subject,
                  :body,
                  :tripcode,
                  :directory,
                  :parent_id,
                  :upload)

  belongs_to :board
  belongs_to :parent, class_name: 'Post'
  has_many :children, class_name: 'Post', :foreign_key => :parent_id
  has_many :reports

  has_attachment :upload, accept: [:jpg, :png, :gif]

  before_save :parse_name
  # before_destroy :check_tripcode

  # TODO: Validate existance of directory
  validates_presence_of :directory
  validates_presence_of(:body,
                        :if => :body_required?)
  validates_presence_of(:upload, 
                        :if => :upload_required?)


  validate :upload_file_size

  # Maximum length is also limited 
  # in the post.js.coffeescript.
  validates_length_of :body, maximum: 800

  def date
    self.created_at.strftime("%Y-%m-%d %l:%M %p %Z")
  end

  def destroy_with_tripcode(input)
    if self.tripcode == crypt_tripcode(input)
      status = Cloudinary::Uploader.destroy(self.upload.public_id)
      self.destroy
    end
  end

  private
    def upload_file_size
    end

    # A body is required if an image is not given.
    def body_required?
      return !self.upload?
    end

    # An image is required if the post is a parent 
    # or if the body is blank.
    def upload_required?
      if self.parent # post is a reply
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