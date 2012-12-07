# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper
  include Cloudinary::CarrierWave        

  version :formatted do
    cloudinary_transformation :angle => :exif
  end

  # I'd just like to thank Cloudinary 
  # for having documentation that emulates the Cretan Labyrinth
  # Most information can be found at: http://bit.ly/HqzgNt
  version :showcase, :from => :formatted do
    cloudinary_transformation( 
      transformation: [ { width: 300, crop: 'fill'},
                        { width: 300, height: 500, crop: 'crop' }])


    process convert: 'jpg'
    # This isn't documented anywhere.
    cloudinary_transformation quality: 90
    cloudinary_transformation :angle => :exif
  end

  version :thumbnail do
    process resize_to_limit: [200, 200]
    process convert: 'jpg'

    cloudinary_transformation quality: 90
    cloudinary_transformation :angle => :exif
  end

  def get_geometry
    if @file
      image = MiniMagick::Image.open(@file.file)
      if image
        return { width: image[:width], height: image[:height] }
      else
        return nil
      end
    end
  end

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_white_list
    %w(jpg jpeg gif png)
  end
end