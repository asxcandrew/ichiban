module BoardsHelper
  def link_to_board(*text, board)
    text = text.empty? ? board.directory : text.to_sentence
    link_to(text, board_path(board))
  end
end
