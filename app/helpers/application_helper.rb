module ApplicationHelper
  def post_article_tag(post, options={}, &block)
    attributes = {}

    if post.tripcode_hex
      options[:style] = "border-left-color: #{border_color(post.tripcode_hex)}"
    end

    output = ActiveSupport::SafeBuffer.new
    output.safe_concat(tag(:article, options, true))

    output << capture(&block)
    output.safe_concat("</article>")
  end


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

  def link_to_board(*text, board)
    text = text.empty? ? board.directory : text.to_sentence
    link_to(text, board_path(board))
  end

  def link_to_post(*text, post)
    text = text.empty? ? post.id : text.to_sentence
    link_to(text, board_post_path(@board, post))
  end

  def link_to_parent(post)
    link_to(content_tag(:i, nil, class: "icon-chevron-up"), 
            board_post_path(@board, post))
  end
end
