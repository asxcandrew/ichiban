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
        ip_address: post.ip_address
        reason: prompt("Reason for suspension?")
        
    unless params.suspension.reason == null
      params.suspension.ends_at = prompt("How long until the suspension is over? ('two days', '1 week from now', etc.)")

    $.post "/suspensions/", params, (response) ->
      returnVal = response
      window.ss = response
      if response.success
        flash("notice", response.message)
      else
        flash("error", response.message)

deleteSuspension = (id) ->
  $.post "/suspensions/#{id}", { _method: 'delete' },
  (response) ->
    if response.success
      $("##{id}").hide(250)
      setSuspensionCounter(response.total)
      flash("notice", response.message)
    else
      flash("error", response.message)
      
setSuspensionCounter = (total) ->
  label = if total == 1 then "Suspension" else "Suspensions"
  $('#suspension-counter').text("#{total} #{label}")