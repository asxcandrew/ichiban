module MarkdownConverter
  def markdown(text = '')
    unless text.nil?
      text = Rack::Utils.escape_html(text)
      text.gsub!("&gt;", '>')

      text.gsub!('\n', '<br />')
      markdown = $MarkdownRenderer.render(text)

      markdown.gsub!("&amp;", '&')

      return markdown
    end
  end

  def strip_markdown(options = { text: '' })
    text = options[:text]
    newline = "\n"
    replacement = options[:html_newlines] ? "<br />" : newline
    unless text.nil?
      text.gsub!(newline) do |instance|
        "^^newline^^#{instance}"
      end

      text = $MarkdownStripper.render(text)
      text.gsub!('^^newline^^', replacement)

      return text
    end
  end
end
