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

  $(".reports").on "click", ".suspend-poster", (e) ->
    e.preventDefault()
    $this = $(this)
    # REWRITE: Remove reports after suspension is sent through.
    suspendPoster($this.data('postid'))

  $(details).on "click", ".report-post", (e) ->
    e.preventDefault()
    reportPost($(this).data('id'))

@reportPost = (id) ->
  params = 
    _method: 'create',
    report: 
      post_id: id, 
      comment: prompt("Why are you reporting post ##{id}?")

  $.ajax
    type: 'POST'
    url: "/reports/"
    data: params
    success: (response) ->
      $.cookie("reported_post_#{id}", true)
      $("##{id} article:first").addClass('uninteresting')
    complete: (response) ->
      flash($.parseJSON(response.responseText).flash)

deleteReport = (id) ->
  $.ajax
    type: 'POST'
    url: "/reports/#{id}"
    data: { _method: 'delete' }
    success: (response) ->
      $("##{id}").hide quickly, () ->
        $(this).empty().remove()
        updateCounter('report', '.reports .report')
    complete: (response) ->
      flash($.parseJSON(response.responseText).flash)

deletePost = (postID, reportID) ->
  $.ajax
    type: 'POST'
    url: "/posts/#{postID}"
    data: { _method: 'delete' }
    success: (response) ->
      deletedReports = $("tr[data-postID = #{postID}]")
      deletedReports.each (i, report) ->
        $(report).hide quickly, () ->
          $(this).empty().remove()
          updateCounter('report', '.reports .report')
    complete: (response) ->
      flash($.parseJSON(response.responseText).flash)