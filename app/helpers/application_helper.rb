module ApplicationHelper
  def title
    text = @prefix ? "#{@prefix} :: Ichiban!" : "Ichiban!"
    content_tag("title", text)
  end

  def markdown(text)
    options = { hard_wrap: true,
                filter_html: true,
                autolink: true,
                no_intraemphasis: true,
                fenced_code: true,
                gh_blockcode: true }
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, options)
    markdown.render(text).html_safe
  end
end
