$ ->  
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
    deletePost($(this).data('id'))

deletePost = (id) ->
  # Request a redirect if we're deleting the parent.
  params = { _method: 'delete', redirect: $("##{id}").hasClass('parent') }

  unless params.redirect
    $parent = $("##{id}").parents('.parent')

  $.ajax
    type: 'POST'
    url: "/posts/#{id}"
    data: params
    success: (response) ->
      if response.redirect
        window.location = response.redirect
      else
        $("##{id}").hide animationDuration, () ->
          $(this).empty().remove()
          flash(response.flash)
          updateReplyCounter($parent.attr('id'))
    error: (response) ->
      $("##{id} .confirmation-toggle:first").hide()
      $("##{id} .delete-post-confirmation:first").show()
      flash($.parseJSON(response.responseText).flash)
