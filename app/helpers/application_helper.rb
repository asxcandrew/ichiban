module ApplicationHelper
  def title
    text = @prefix ? "#{@prefix} :: Ichiban!" : "Ichiban!"
    content_tag("title", text)
  end

  def markdown(text)
    options = [ :hard_wrap,
                :filter_html,
                :autolink,
                :no_intraemphasis,
                :fenced_code,
                :gh_blockcode ]

    Redcarpet.new(text, *options).to_html.html_safe
  end

  def link_to_board(*text, board)
    text = text.empty? ? board.directory : text.to_sentence
    link_to(text, board_path(board))
  end

  def link_to_post(*text, post)
    text = text.empty? ? post.id : text.to_sentence
    link_to(text, board_post_path(@board, post))
  end
end
