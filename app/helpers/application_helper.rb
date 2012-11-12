module ApplicationHelper
  include IchibanAuthorization
  
  def title
    text = @prefix ? "#{@prefix} :: #{Setting.site_name}" : Setting.site_name
    content_tag("title", text)
  end

  def markdown(text)
    text.nil? ? '' : $MarkdownRenderer.render(h(text))
  end

  def pluralize_without_count(count, noun, text = nil)
    count == 1 ? "#{noun}#{text}" : "#{noun.pluralize}#{text}"
  end

  # Try to calculate time on the client side when you can.
  def human_time(time)
    tense = Time.now > time ? "ago" : "from now"
    "#{time_ago_in_words(time)} #{tense}.".capitalize
  end

  def body_tag(options={}, &block)
    output = ActiveSupport::SafeBuffer.new

    # Nothing to see here.    
    options[:class] << " kidz-zone" if Date.today.month == 2 && Date.today.day == 29

    output.safe_concat(tag(:body, options, true))
    output << capture(&block)
    output.safe_concat("</body>")
  end
end