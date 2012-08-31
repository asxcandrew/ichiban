$ ->
  $(document).on "click", ".reply-toggle", (e) ->
    e.preventDefault()
    toggleReply($(this).data('id'))
  
  # The body limitation is also validated in
  # post model.
  $('textarea').limiter(maxLength: 800)

  # FIX: issue where child posts are deleted.
  $(".post").on "click", ".delete-post", (e) ->
    e.preventDefault()
    deletePost($(this).data('id'))

  $("figure").on "click", "a", (e) ->
    e.preventDefault()
    toggleImageExpansion($(this))

toggleImageExpansion = ($link) ->
  image = $link.children("img")

  if image.data("srcToggle")
    src = image.data("srcToggle")
  else
    src = $link.attr("href")
    
  image.data("srcToggle": image.attr("src"))

  image.attr(
    'src': src
    height: null
    width: null)

toggleReply = (id) ->
  reply = "##{id} .reply:first"
  $(reply).toggle(250)
  
  # Jump to the reply
  $('body').animate { scrollTop: $(reply).offset().top }, 200, () ->
    $("#{reply} textarea#post_body").focus()

deletePost = (id) ->
  tripcode = prompt("Enter your tripcode to delete post ##{id}.")

  if tripcode != null && tripcode.length != 0
    $.post "/boards/test/#{id}", { _method: 'delete', tripcode }, 
      (response) ->
        if response.success
          if response.redirect
            window.location = response.redirect
          else
            $("##{id}").hide(250)
            flash("notice", response.message)

        else
          flash("error", response.message)
  else
    flash("error", "No tripcode entered.")

@updateMeter = (percentage, meter) ->
  percentage = Math.min(percentage, 100)
  $(meter).css("width", "#{percentage}%")