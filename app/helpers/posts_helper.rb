module PostsHelper
  def post_article_tag(post, options={}, &block)
    attributes = {}
    options[:style] = "border-left-color: #{border_color(post.color)}"

    output = ActiveSupport::SafeBuffer.new
    output.safe_concat(tag(:article, options, true))

    output << capture(&block)
    output.safe_concat("</article>")
  end

  def link_to_post(*text, post)
    text = text.empty? ? post.id : text.to_sentence
    link_to(text, board_post_path(@board, post))
  end

  def link_to_parent(post)
    link_to(content_tag(:i, nil, class: "icon-chevron-up"), 
            board_post_path(@board, post))
  end

  def link_to_upload(path)
    cl_path = cl_image_path(path)

    link_to(cl_path) do
      cl_image_tag(path, { width: '250', :crop => :limit, 'data-toggle' => cl_path })
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
