module BoardsHelper
  def link_to_board(*text, board)
    text = text.empty? ? board.directory : text.to_sentence
    link_to(text, board_path(board))
  end

  def link_back_to_board
    text = content_tag(:i, nil, class: "icon-arrow-left")
    text << "&nbsp;".html_safe + t('.back_to_board', board: @board.name.titleize)
    link_to_board(text, @board)
  end

  def link_back_to_directory
    text = content_tag(:i, nil, class: "icon-arrow-left")
    text << "&nbsp;".html_safe + t('.back_to_directory')
    link_to(text, boards_path)
  end
end
