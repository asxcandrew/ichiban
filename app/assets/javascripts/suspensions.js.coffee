$ ->
  $(".suspensions").on "click", ".delete-suspension", (e) ->
    e.preventDefault()
    deleteSuspension($(this).data('id'))

  $(window.controls).on "click", ".suspend-poster", (e) ->
    e.preventDefault()
    suspendPoster($(this).data('id'))

@suspendPoster = (id) ->
  $.getJSON "/posts/#{id}.json", (post) ->
    params = 
      _method: 'create'
      suspension:
        post_id: post.id
        board_id: post.board_id
        ip_address: post.ip_address
        reason: prompt("Reason for suspension?")
        
    unless params.suspension.reason == null
      params.suspension.ends_at = prompt("How long until the suspension is over? ('two days', '1 week from now', etc.)")

    $.ajax
      type: 'POST'
      url: "/account/boards/1/suspensions/"
      data: params
      complete: (response) ->
        flash($.parseJSON(response.responseText).flash)

deleteSuspension = (id) ->
    $.ajax
      type: 'POST'
      url: "/suspensions/#{id}"
      data: { _method: 'delete' }
      success: (response) ->
        $("##{id}").hide quickly, () ->
            $(this).empty().remove()
            updateCounter('suspension', '.suspensions .suspension')
      complete: (response) ->
        flash($.parseJSON(response.responseText).flash)