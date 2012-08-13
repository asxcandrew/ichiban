module ApplicationHelper
  def title
    text = @prefix ? "#{@prefix} :: Ichiban!" : "Ichiban!"
    content_tag("title", text)
  end

  def link_to_directory(*text, board)
    text = board.directory if text.empty?
    path = url(:boards, :index, directory: board.directory)
    link_to(text, path)
  end

  # This method will accept a hash of directives or a Post object.
  def link_to_post(*text, post)
    if post.is_a? Post
      post = { directory: post.directory, id: post.id }
    end

    # Link will output as the post ID if nothing is specified.
    text = post.id if text.empty?

    path = url(:boards, :thread, post)

    link_to(text, path)
  end
end
