$ ->
  $(".reports").on "click", ".delete-report", (e) ->
    e.preventDefault()
    deleteReport($(this).data('id'))



deleteReport = (id) ->
  $.post "/reports/#{id}", { _method: 'delete', report: { id } },
  (response) ->
    if response.success
      $("##{id}").hide(250)
      flash("notice", response.message)
    else
      flash("error", response.message)