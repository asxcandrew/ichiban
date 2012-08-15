# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper
  process :store_geometry => :image

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  version :thumbnail do
    process :resize_to_fit => [250, 250]
    process :store_geometry => :thumbnail
  end
  
  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def store_geometry(version)
    # File refers to our upload in progress.
    if @file
      img = ::Magick::Image::read(@file.file).first
      # Model refers to our Post model.
      if model
        model.send("#{version}_width=", img.columns) 
        model.send("#{version}_height=", img.rows) 
      end
    end
  end

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

end
