module PostsHelper
  def post_tag(post, options={}, &block)
    output = ActiveSupport::SafeBuffer.new
    classes = ["post", options[:class]]
    classes << "ancestor" if post.is_ancestor?

    options.merge!(
      { class: classes,
        id: post.id,
        "data-directory" => post.board.directory })
    options["data-ip"] = post.ip_address if can?(:manage, Post)

    output.safe_concat(tag(:div, options, true))
    output << capture(&block)
    output.safe_concat("</div>")
  end

  def post_article_tag(color, options={}, &block)
    output = ActiveSupport::SafeBuffer.new
    if color
      options[:style] = 
        "border-color: #{post_color(color)}; 
         background-color: #{background_color(color)};"
    end

    output.safe_concat(tag(:article, options, true))
    output << capture(&block)
    output.safe_concat("</article>")
  end

  def link_to_post(*text, post)
    text = text.empty? ? "##{post.id}" : text.to_sentence
    link_to(text, post_path(post), title: "Post ##{post.id}")
  end

  def link_to_parent(post)
    link_to(content_tag(:i, nil, class: "icon-chevron-up", title: "Parent ##{post.id}"), 
            post_path(post))
  end

  def link_to_ancestor(post)
    link_to(content_tag(:i, nil, class: "icon-sitemap", title: "Ancestor ##{post.id}"), 
            post_path(post))
  end

  def link_to_image(asset, size, options = {})
    # REFACTOR: It's quite the assumption to guess that all GIF files are animated.
    #           Though I'd rather be wrong 1% of the time then not address it.
    options[:class] = "animated" if asset.format =~ /gif/i

    link_to(asset.formatted.to_s, options) do
      image_tag(asset.send(size).to_s, 'data-toggle' => asset.formatted.to_s)
    end
  end

  def post_color(hex)
    # We can take the tripcode hex for what it is but the color
    # may be too strong for our layout.
    saturation_limit = 35.0
    lightness_limit = 55.0
    # HACK: There's gotta be better way to deal with this.
    unless hex.nil?
      color = Color::RGB.from_html(hex).to_hsl
      color.saturation = saturation_limit if color.saturation > saturation_limit
      color.lightness = lightness_limit if color.lightness > lightness_limit

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
end
