class Image < ActiveRecord::Base
  attr_accessible :asset, :post_id
  belongs_to :imageable, polymorphic: true
  mount_uploader :asset, ImageUploader

  validates_presence_of :width
  validates_presence_of :height
  validates_presence_of :md5

  before_validation :read_dimensions
  before_validation :generate_md5

  def read_dimensions
    dimensions = self.asset.get_geometry
    if dimensions.nil?
      errors.add(:file_error, I18n.t('images.errors.file_error'))
    else
      self.width = dimensions[:width]
      self.height = dimensions[:height]
    end
  end

  def generate_md5
    if self.asset.path
      self.md5 = Digest::MD5.file(self.asset.path).hexdigest
    else
      errors.add(:file_error, I18n.t('images.errors.file_error'))
    end
  end

  def showcase_height
    if self.width && self.height
      ratio = 300.0 / self.width
      (self.height * ratio).ceil
    end
  end
end
