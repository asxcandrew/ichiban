class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  PNG = %w(png)
  JPG = %w(jpg jpeg)

  def store_dir
    'public/my/upload/avatar'
  end

  process :resize_to_fit => [300,300]

  def filename 
    if original_filename 
      @name ||= Digest::MD5.hexdigest(File.dirname(current_path))
      "#{@name}.#{file.extension}"
    end
  end

  def extension_white_list
    PNG + JPG
  end
end
