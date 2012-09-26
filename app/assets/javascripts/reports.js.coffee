$ ->
  $(".reports").on "click", ".delete-report", (e) ->
    e.preventDefault()
    deleteReport($(this).data('id'))

  $(".reports").on "click", ".delete-post", (e) ->
    e.preventDefault()
    $this = $(this) # Not going to ask for this twice...

    reportID = $this.parent().parent().attr('id')
    postID = $this.data('id')
    deletePost(postID, reportID)

deleteReport = (id) ->
  $.post "/reports/#{id}", { _method: 'delete', getReportTotal: true },
  (response) ->
    if response.success
      $("##{id}").hide(250)
      setReportCounter(response.report_total)
      flash("notice", response.message)
    else
      flash("error", response.message)

deletePost = (postID, reportID) ->
  $.post "/posts/#{postID}", { _method: 'delete', getReportTotal: true },
  (response) ->
    if response.success
      deletedReports = $("tr[data-postID = #{postID}]")
      deletedReports.each (i, report) ->
        $(report).hide(250)

      setReportCounter(response.report_total)
      flash("notice", response.message)
    else
      flash("error", response.message)

setReportCounter = (total) ->
  $('#report-counter').text(total)