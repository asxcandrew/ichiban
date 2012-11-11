# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  # include CarrierWave::RMagick
  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper
  include Cloudinary::CarrierWave        

  version :formatted do
    cloudinary_transformation :angle => :exif
  end

  version :thumbnail do
    process resize_to_limit: [250, 250]
    process convert: 'jpg'

    # This isn't documented anywhere. Thanks Cloudinary.
    cloudinary_transformation quality: 90
    cloudinary_transformation :angle => :exif
  end

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_white_list
    %w(jpg jpeg gif png)
  end
end