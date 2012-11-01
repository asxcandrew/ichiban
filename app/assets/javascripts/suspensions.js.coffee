$ ->
  $(".suspensions").on "click", ".delete-suspension", (e) ->
    e.preventDefault()
    deleteSuspension($(this).data('id'))

  $(window.controls).on "click", ".suspend-poster", (e) ->
    e.preventDefault()
    sunspendPoster($(this).data('id'))

sunspendPoster = (id) ->
  $post = $("##{id}")
  params = 
    _method: 'create'
    suspension:
      post_id: id
      ip_address: $post.data('ip')
      reason: prompt("Reason for suspension?")
      
  if typeof(params.suspension.reason) == 'undefined'
    params.suspension.ends_at = prompt("How long until the suspension is over? ('two days', '1 week from now', etc.)")

  $.post "/suspensions/", params, (response) ->
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