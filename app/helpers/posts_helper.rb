module PostsHelper
  def link_to_post(*text, post)
    text = text.empty? ? post.id : text.to_sentence
    link_to(text, board_post_path(@board, post))
  end

  def link_to_parent(post)
    link_to(content_tag(:i, nil, class: "icon-chevron-up"), 
            board_post_path(@board, post))
  end

  def link_to_upload(path)
    link_to(cl_image_path(path)) do
      cl_image_tag(path, width: '250', :crop => :limit)
    end
  end

  def human_date(post)
    "#{time_ago_in_words(post.created_at)} ago.".capitalize
  end

  def border_color(hex)
    # We can take the tripcode hex for what it is but the brightness
    # may be too strong for our layout.
    limit = 75.0
    color = Color::RGB.from_html(hex)
    color.brightness = limit if color.brightness > limit

    color.html
  end
end
