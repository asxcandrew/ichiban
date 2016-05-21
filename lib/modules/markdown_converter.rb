module MarkdownConverter
  def markdown(text = '')
    unless text.nil?
      text = Rack::Utils.escape_html(text)
      text.gsub!('&gt;', '>')
      text.gsub!('\n', '<br />')
      markdown = $MarkdownRenderer.render(text)
      markdown.gsub!('&amp;', '&')

      return markdown
    end
  end

  def strip_markdown(text, html_newlines)
    if options[:text].present?
      text = $MarkdownStripper.render(options[:text])
      text.gsub!('\n', '<br />') if html_newlines
    end
    text
  end
end
