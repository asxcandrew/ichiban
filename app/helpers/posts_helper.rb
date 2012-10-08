module PostsHelper
  def post_tag(post, options={}, &block)
    output = ActiveSupport::SafeBuffer.new

    options.merge!(
      { class: "post #{options[:class]}",
        id: post.id,
        "data-directory" => post.directory })
    options["data-ip"] = post.ip_address if can?(:manage, Post)

    output.safe_concat(tag(:div, options, true))
    output << capture(&block)
    output.safe_concat("</div>")
  end

  def post_article_tag(color, options={}, &block)
    output = ActiveSupport::SafeBuffer.new
    options[:style] = "border-left-color: #{border_color(color)}"

    output.safe_concat(tag(:article, options, true))
    output << capture(&block)
    output.safe_concat("</article>")
  end

  def link_to_post(*text, post)
    text = text.empty? ? "##{post.id}" : text.to_sentence
    link_to(text, board_post_path(post.directory, post))
  end

  def link_to_parent(post)
    link_to(content_tag(:i, nil, class: "icon-chevron-up"), 
            board_post_path(@board, post))
  end

  def link_to_image(asset)
    link_to(asset.to_s) do
      image_tag(asset.thumbnail, 'data-toggle' => asset)
    end
  end

  def human_date(post)
    "#{time_ago_in_words(post.created_at)} ago.".capitalize
  end

  def border_color(hex)
    # We can take the tripcode hex for what it is but the color
    # may be too strong for our layout.
    saturation_limit = 35.0
    lightness_limit = 48.8
    # HACK: There's gotta be better way to deal with this.
    color = Color::RGB.from_html(hex).to_hsl
    color.saturation = saturation_limit if color.saturation > saturation_limit
    color.lightness = lightness_limit if color.lightness > lightness_limit

    color.html
  end
end
