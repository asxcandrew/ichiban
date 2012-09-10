module ColorDigest
  # We store the hex output of a user's tripcode or IP
  # as a color variable.
  def input_to_color(input)
    unless input.blank?
      Digest::MD5.hexdigest(input)[0..5]
    end
  end
end