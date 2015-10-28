module PostsHelper

  COLORS = {
    sky_blue: '#d7e3f4',
    blue: '#e2e7f0',
    thistle: '#eedfde',
    beige: '#f0eed8',
    plum: '#eae1f0',
    khaki: '#d8decf',
    gray: '#e4e4e4'
  }

  def post_tag(post, options={}, &block)
    attributes = { class: ['post'],
                   id: post.related_id,
                   "data-directory" => post.board.directory,
                   style: [] }

    attributes[:class] << 'ancestor' if post.is_ancestor?
    attributes[:class] << options[:class]
    attributes['data-ip'] = post.ip_address if can?(:manage, Post)
    attributes[:tabindex] = @counter += 1
    if post.is_child?
      border_color = post_color(hex: COLORS[post.board.color.to_sym])
      attributes[:style] << "border-left-color: #{border_color};"
    end

    content_tag(:div, attributes) do
      capture(&block)
    end
  end

  def post_addition_tag(post)
    #   .left
    # figure
    #   == image_tag(post.image.asset.thumbnail)
  end

  def post_article_tag(options = {}, &block)
    attributes = { class: '' }
    color = COLORS[options[:color].to_sym]
    if color
      attributes[:style] = 
        "border-color: #{post_color(hex: color)}; 
         background-color: #{color};"
    end
    attributes[:class] << 'uninteresting' if cookies["reported_post_#{options[:id]}"]

    content_tag(:article, attributes) do
      capture(&block)
    end
  end

  def post_path(post, options = {})
    board_post_path(post.board, post.related_id, options)
  end

  def link_to_post(*text, post, &block)
    text = text.empty? ? "##{post.related_id}" : text.to_sentence
    if block.nil?
      link_to(text, board_post_path(post.board, post.related_id), title: "Post ##{post.related_id}")
    else
      link_to(board_post_path(post.board, post.related_id), &block)
    end
  end

  def link_to_parent(post)
    link_to(content_tag(:i, nil, class: "icon-chevron-up", title: "Parent ##{post.id}"), 
            board_post_path(post.board, post))
  end

  def link_to_ancestor(post)
    link_to(content_tag(:i, nil, class: "icon-sitemap", title: "Ancestor ##{post.id}"), 
            board_post_path(post.board, post))
  end

  def link_to_image(asset, size, options = {})
    # REFACTOR: It's quite the assumption to guess that all GIF files are animated.
    #           Though I'd rather be wrong 1% of the time then not address it.
    options[:class] = "animated" if asset.format =~ /gif/i

    link_to(asset.formatted.to_s, options) do
      image_tag(asset.send(size).to_s, 
                'data-toggle' => asset.formatted.to_s, 
                title: I18n.t('posts.show.enlarge_image'))
    end
  end

  def post_color(options = {})
    # We can take the tripcode hex for what it is but the color
    # may be too strong for our layout.
    saturation_limit = 35.0
    lightness_limit = 55.0
    # HACK: There's gotta be better way to deal with this.
    unless options[:hex].nil?
      color = Color::RGB.from_html(options[:hex]).to_hsl
      color.saturation = saturation_limit if color.saturation > saturation_limit
      color.lightness = lightness_limit if color.lightness > lightness_limit

      color.lightness += options[:lighten] if options[:lighten]
      color.html
    end
  end

  def background_color(hex)
    unless hex.nil?
      color = Color::RGB.from_html(hex).to_hsl
      color.lightness = 95.0
      color.html
    end
  end

  def submit_button_style(hex)
    unless hex.nil?
      base_color = post_color(hex: hex)
      gradient_color = post_color(hex: hex, lighten: 2)
      style = "background-color: #{base_color}; "
      style << "background-image: linear-gradient(#{gradient_color}, #{base_color});"
      style << "background-image: -webkit-linear-gradient(#{gradient_color}, #{base_color});"
      style << "background-image: -moz-linear-gradient(#{gradient_color}, #{base_color});"
      return style
    end
  end
end
