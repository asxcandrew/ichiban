module BoardsHelper
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

  def showcase_tag(post, options={ class: "showcase " }, &block)
    output = ActiveSupport::SafeBuffer.new
    options[:class] << post.board.directory
    options[:class] << " nsfw" unless post.worksafe?

    options[:style] = "height: #{post.image.showcase_height}px;"

    options[:id] = post.id

    output.safe_concat(tag(:div, options, true))
    output << capture(&block)
    output.safe_concat("</div>")
  end
end
