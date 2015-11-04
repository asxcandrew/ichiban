$ ->
  $(".reports").on "click", ".delete-report", (e) ->
    e.preventDefault()
    deleteReport($(this).data('id'))

  $(".reports").on "click", ".delete-post", (e) ->
    e.preventDefault()
    $this = $(this) # Not going to ask for this twice...

    postID = $this.data('id')
    boardDir = $this.data('board-dir')

    deletePost(postID, boardDir)

  $(".reports").on "click", ".suspend-poster", (e) ->
    e.preventDefault()
    $this = $(this)
    # REWRITE: Remove reports after suspension is sent through.
    suspendPoster($this.data('postid'), $this.data('board-dir'))

  $(details).on "click", ".report-post", (e) ->
    e.preventDefault()
    reportPost($(this).data('id'), $(this).data('global-id'))

@reportPost = (id, global_id) ->
  params = 
    _method: 'create',
    report: 
      post_id: global_id, 
      comment: prompt("Why are you reporting post ##{id}?")

  $.ajax
    type: 'POST'
    url: "/reports/"
    data: params
    success: (response) ->
      $.cookie("reported_post_#{global_id}", true)
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

deletePost = (postID, boardDir) ->
  $.ajax
    type: 'POST'
    url: "/boards/#{boardDir}/posts/#{postID}"
    data: { _method: 'delete' }
    success: (response) ->
      deletedReports = $("tr[data-postID = #{postID}]")
      deletedReports.each (i, report) ->
        $(report).hide quickly, () ->
          $(this).empty().remove()
          updateCounter('report', '.reports .report')
    complete: (response) ->
      flash($.parseJSON(response.responseText).flash)
