$ ->
  $(".reports").on "click", ".delete-report", (e) ->
    e.preventDefault()
    deleteReport($(this).data('id'))

  $(".reports").on "click", ".delete-post", (e) ->
    e.preventDefault()
    deletePost($(this).data('id'))



deleteReport = (id) ->
  $.post "/reports/#{id}", { _method: 'delete' },
  (response) ->
    if response.success
      $("##{id}").hide(250)
      $('#report-counter').text(response.report_total)
      flash("notice", response.message)
    else
      flash("error", response.message)

deletePost = (id) ->
  $.post "/posts/#{id}", { _method: 'delete' },
  (response) ->
    if response.success
      $("##{id}").hide(250)
      flash("notice", response.message)
    else
      flash("error", response.message)
