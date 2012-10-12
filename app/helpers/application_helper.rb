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

  def pluralize_without_count(count, noun, text = nil)
    count == 1 ? "#{noun}#{text}" : "#{noun.pluralize}#{text}"
  end

  def human_date(date)
    "#{time_ago_in_words(date)} ago.".capitalize
  end
end
