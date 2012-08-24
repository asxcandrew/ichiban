$ ->
  $(document).on "click", ".reply-toggle", () ->
    toggleReply($(this).data('id'))
  
  $('textarea').limiter(maxLength: 800)

  $(document).on "click", ".delete-post", () ->
    deletePost($(this).data('id'))

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
          $("##{id}").hide(250)
          flash("notice", response.message)
          if response.redirect
            console.log("REDIRECT")
        else
          flash("error", response.message)
  else
    flash("error", "No tripcode entered.")

@updateMeter = (percentage, meter) ->
  percentage = Math.min(percentage, 100)
  $(meter).css("width", "#{percentage}%")