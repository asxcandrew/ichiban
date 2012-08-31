module PostsHelper
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
