# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper

  PNG = %w(png)
  JPG = %w(jpg jpeg)
  GIF = %w(gif)

  def extension_white_list
    PNG + JPG + GIF
  end

  def store_dir
    'public/uploads/images'
  end

  def filename 
    if original_filename 
      @name ||= Digest::MD5.hexdigest(File.dirname(current_path))
      "#{@name}.#{file.extension}"
    end
  end

  version :thumbnail do
    process :resize_to_fit => [300,300]
  end

  # version :thumbnail, :if => :gif? do
  #   Rails.logger.debug 'GIF'
  #   process :resize_to_fit => [300,300]
  #   process :convert => 'png'
  #   # process :set_content_type
  #   def filename
  #     change_ext_to_png(super)
  #   end
  # end

  def change_ext_to_png(ext)
    ext.chomp(File.extname(ext)) + ".png"
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

  protected

  def gif?(new_file)
    extension = my_model.file.file.extension.downcase
    GIF.include?(extension)
  end

end