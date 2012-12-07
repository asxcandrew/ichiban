module MarkdownConverter
  def markdown(text = '')
    unless text.nil?
      # HACK: Recarpet's html filter is lackluster. We can filter using Rack but this breaks quotes.
      text = Rack::Utils.escape_html(text)
      text.gsub!("&gt;", '>')

      markdown = $MarkdownRenderer.render(text)
      markdown.gsub!("&amp;", '&')

      return markdown
    end
  end

  def strip_markdown(options = { text: '' })
    # HACK: Redcarpet's stripper function eats newlines. This is seriously the best Markdown gem?
    text = options[:text]
    newline = "\n"
    replacement = options[:html_newlines] ? "<br />" : newline
    unless text.nil?
      text.gsub!(newline) do |instance|
        instance.prepend('^^newline^^')
      end

      text = $MarkdownStripper.render(text)
      text.gsub!('^^newline^^', replacement)

      return text
    end
  end
end