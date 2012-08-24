$ ->
  $(".post").on "click", ".reply-toggle", () ->
    toggleReply($(this).data('id'))
  
  $('textarea').limiter(maxLength: 800)

  $(".post").on "click", ".delete-post", () ->
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
    $("#{reply} input#post_name").focus()

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