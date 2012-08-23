class Post < ActiveRecord::Base
  include Tripcode
  attr_accessible :name, :subject, :body, :tripcode, :directory, :parent_id, :image

  belongs_to :board
  belongs_to :parent, class_name: 'Post'
  has_many :children, class_name: 'Post', :foreign_key => :parent_id

  before_save :parse_name
  # Carrierwave magic
  mount_uploader :image, ImageUploader

  def date
    self.created_at.strftime("%Y-%m-%d %l:%M %p %Z")
  end

  def parse_name
    input = self.name
    hash_pos = input.index('#')

    if hash_pos
      name = hash_pos == 0 ? 'Anonymous' : input[0...hash_pos]
      
      # Everything after the hash.
      password = input[ ((hash_pos + 1)..-1) ]

      self.tripcode = crypt_tripcode(password)
      self.name = name
    else
      self.name = input.empty? ? "Anonymous" : input
    end
  end

  def destroy(input)
    self.delete if (self.tripcode == crypt_tripcode(input))
  end

end