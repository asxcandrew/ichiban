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
    
  $(window.controls).on "click", ".report-post", (e) ->
    e.preventDefault()
    reportPost($(this).data('id'))

reportPost = (id) ->
  params = 
    _method: 'create',
    report: 
      post_id: id, 
      comment: prompt("Why are you reporting post ##{id}?")

  $.post "/reports/", params, (response) ->
    if response.success
      flash("notice", response.message)
    else
      flash("error", response.message)

deleteReport = (id) ->
  $.post "/reports/#{id}", { _method: 'delete' },
  (response) ->
    if response.success
      $("##{id}").hide animationDuration, () ->
        $(this).empty().remove()
        updateReportCounter()

      flash("notice", response.message)
    else
      flash("error", response.message)

deletePost = (postID, reportID) ->
  $.post "/posts/#{postID}", { _method: 'delete' },
    (response) ->
      if response.success
        deletedReports = $("tr[data-postID = #{postID}]")
        deletedReports.each (i, report) ->
          $(report).hide animationDuration, () ->
            $(this).empty().remove()
            updateReportCounter()

        flash("notice", response.message)
      else
        flash("error", response.message)

updateReportCounter = () ->
  total = $('.reports .report').length
  label = if total == 1 then "Report" else "Reports"
  $('#report-counter').text("#{total} #{label}")