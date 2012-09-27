$ ->
  $(document).on "click", ".reply-toggle", (e) ->
    e.preventDefault()
    toggleReply($(this).data('id'))
  
  # The body limitation is also validated in
  # post model.
  $('textarea').limiter(maxLength: 800)

  # FIX: issue where child posts are deleted.
  $(".post footer").on "click", ".delete-post-with-tripcode", (e) ->
    e.preventDefault()
    deletePost($(this).data('id'), { askForTripcode: true })

  $(".post footer").on "click", ".delete-post", (e) ->
    e.preventDefault()
    $this = $(this)
    if $this.data('asked') == 'yes'
      deletePost($this.data('id'), { askForTripcode: false })
    else
      $this.data('asked', 'yes')
      $this.text('really?')
      setTimeout (-> 
        $this.text("delete")
        $this.data('asked', 'no')), 3000


  $(".post footer").on "click", ".report-post", (e) ->
    e.preventDefault()
    reportPost($(this).data('id'))

  $("figure").on "click", "a", (e) ->
    e.preventDefault()
    toggleImageExpansion($(this))

toggleImageExpansion = ($link) ->
  image = $link.children("img")

  oldSource = image.attr('src')
  newSource = image.data('toggle')

  image.data('toggle': oldSource)

  # HACK: issue where image dimensions are not updated.
  # The following corrects the issue temporarily.
  image.attr('src': newSource).one('load', () ->
    if image.css('max-width') == 'none'
      image.css('max-width': '100%')
    else if image.css('max-width') == '100%'
      image.css('max-width': 'none'))

toggleReply = (id) ->
  reply = "##{id} .reply:first"
  $(reply).toggle(250)
  
  # Jump to the reply
  $('body').animate { scrollTop: $(reply).offset().top }, 200, () ->
    $("#{reply} textarea#post_body").focus()

deletePost = (postID, options) ->
  params = { _method: 'delete' }
  valid = !options["askForTripcode"]

  if options["askForTripcode"] == true
    params['tripcode'] = prompt("Enter your tripcode to delete post ##{postID}.")

    valid = params['tripcode'] != null && params['tripcode'].length != 0
    flash("error", "No tripcode entered.") if not valid

  if valid
    $.post "/posts/#{postID}", params, (response) ->
      if response.success
        if response.redirect
          window.location = response.redirect
        else
          $("##{postID}").hide(250)
          flash("notice", response.message)
      else
        flash("error", response.message)

reportPost = (id) ->
  comment = prompt("Why are you reporting post ##{id}?")

  if comment != null && comment.length >= 4
    $.post "/reports/", { _method: 'create', report: { post_id: id, comment } },
      (response) ->
        if response.success
          flash("notice", response.message)
        else
          flash("error", response.message)
  else
    flash("error", "You must provide a comment with your report.")

@updateMeter = (percentage, meter) ->
  percentage = Math.min(percentage, 100)
  $(meter).css("width", "#{percentage}%")