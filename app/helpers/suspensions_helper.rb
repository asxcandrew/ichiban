module SuspensionsHelper
  def suspension_tr_tag(suspension, options={}, &block)
    output = ActiveSupport::SafeBuffer.new
    classes = [options[:class]]
    classes << "unimportant" if suspension.expired?
    classes << "suspension"

    options.merge!(
      { class: classes,
        id: suspension.id,
        "data-postID" => suspension.post_id })


    output.safe_concat(tag(:tr, options, true))
    output << capture(&block)
    output.safe_concat("</tr>")
  end
end