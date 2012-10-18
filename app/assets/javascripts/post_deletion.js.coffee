$ ->  
  $(window.controls).on "click", ".delete-post-with-tripcode", (e) ->
    e.preventDefault()
    deletePost($(this).data('id'), { askForTripcode: true })

  $(window.controls).on "click", ".delete-post-confirmation", (e) ->
    e.preventDefault()
    $this = $(this)
    $this.hide()
    id = $this.parents('.post').attr('id')
    $("##{id}#{window.controls} .confirmation-toggle:first").show()

  $(window.controls).on "click", ".unconfirm", (e) ->
    e.preventDefault()
    $this = $(this)
    $this.parent().hide()
    id = $this.parents('.post').attr('id')
    $("##{id} .delete-post-confirmation:first").show()


  $(window.controls).on "click", ".delete-post", (e) ->
    e.preventDefault()
    deletePost($(this).data('id'), { askForTripcode: false })

deletePost = (id, options) ->
  # Request a redirect if we're deleting the parent.
  params = { _method: 'delete', redirect: $("##{id}").hasClass('parent') }
  valid = !options["askForTripcode"]

  if options["askForTripcode"] == true
    params['tripcode'] = prompt("Enter your tripcode to delete post ##{id}.")

    valid = params['tripcode'] != null && params['tripcode'].length != 0
    flash("error", "No tripcode entered.") if not valid

  if valid
    $.post "/posts/#{id}", params, (response) ->
      if response.success
        if response.redirect
          window.location = response.redirect
        else
          $("##{id}").hide animationDuration, () ->
            $(this).empty().remove()
            updateReplyCounter()
          flash("notice", response.message)
      else
        flash("error", response.message)