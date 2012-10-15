$ ->
  $(".suspensions").on "click", ".delete-suspension", (e) ->
    e.preventDefault()
    deleteSuspension($(this).data('id'))

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