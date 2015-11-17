module BoardsHelper

  def boards_top(current = false)
    block = ''
    top = Board.top.to_a
    if current
      top.delete current 
      block << link_to("/#{current.directory}", board_path(current), class: 'current top')
    end
    top.each do |board|
      block << link_to("/#{board.directory}", board_path(board), class: 'top')
    end
    block
  end

  def link_to_board(*text, board)
    text = text.empty? ? board.directory : text.to_sentence
    link_to(text, board_path(board))
  end

  def link_to_board_or_root
    if params[:controller] == 'boards' && params[:action] == 'show'
      link_to(@board.name, root_path)  
    else
      link_to_board(@board.name, @board)
    end
  end

  def link_back_to_board
    text = content_tag(:i, nil, class: "icon-arrow-left")
    text << "&nbsp;".html_safe + t('boards.navigation.back_to_board', board: @board.name.titleize)
    link_to_board(text, @board)
  end

  def link_back_to_directory
    text = content_tag(:i, nil, class: "icon-arrow-left")
    text << "&nbsp;".html_safe + t('boards.navigation.back_to_directory')
    link_to(text, root_path)
  end

  def showcase_tag(post, options={ class: ['showcase'] }, &block)
    attributes = { id: post.id, class: [post.board.directory] }
    attributes[:class] << "nsfw" unless post.worksafe?

    content_tag(:div, options) do
      capture(&block)
    end
  end
end
