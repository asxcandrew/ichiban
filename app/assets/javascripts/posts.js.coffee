$ ->
  updateReplyCounter()
  controls = '.post footer'
  # The body limitation is also validated in
  # post model.
  $('textarea').limiter(maxLength: 800)

  $(controls).on "click", ".reply-toggle", (e) ->
    e.preventDefault()
    toggleReply($(this).data('id'))

  $(controls).on "click", ".delete-post-with-tripcode", (e) ->
    e.preventDefault()
    deletePost($(this).data('id'), { askForTripcode: true })

  $(controls).on "click", ".delete-post", (e) ->
    e.preventDefault()
    $deleteLink = $(this)
    if $deleteLink.data('asked') == 'yes'
      deletePost($deleteLink.data('id'), { askForTripcode: false })
    else
      $deleteLink.data('asked', 'yes')
      $deleteLink.text('really?')
      setTimeout (-> 
        $deleteLink.text("delete")
        $deleteLink.data('asked', 'no')), 3000

  $(controls).on "click", ".report-post", (e) ->
    e.preventDefault()
    reportPost($(this).data('id'))

  $(controls).on "click", ".suspend-poster", (e) ->
    e.preventDefault()
    sunspendPoster($(this).data('id'))

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
    $("#{reply} textarea:first").focus()

deletePost = (id, options) ->
  # Request a redirect if we're deleting the parent.
  params = { _method: 'delete', redirect: $("##{id}").hasClass('parent') }
  valid = !options["askForTripcode"]

  if options["askForTripcode"] == true
    params['tripcode'] = prompt("Enter your tripcode to delete post ##{id}.")

    valid = params['tripcode'] != null && params['tripcode'].length != 0
    flash("error", "No tripcode entered.") if not valid

  if valid
    $.post "/posts/#{id}", params, (response) ->
      if response.success
        if response.redirect
          window.location = response.redirect
        else
          $("##{id}").hide 250, () ->
            $(this).empty().remove()
            updateReplyCounter()
          flash("notice", response.message)
      else
        flash("error", response.message)

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

sunspendPoster = (id) ->
  $post = $("##{id}")
  params = 
    _method: 'create',
    suspension:
      post_id: id,
      ip_address: $post.data('ip')
      reason: prompt("Reason for suspension?")
    # ends_at: prompt("How long?")
  $.post "/suspensions/", params, (response) ->
    if response.success
      flash("notice", response.message)
    else
      flash("error", response.message)


@updateMeter = (percentage, meter) ->
  percentage = Math.min(percentage, 100)
  $(meter).css("width", "#{percentage}%")

updateReplyCounter = () ->
  posts = $('.parent .post').length
  label = if posts == 1 then "reply" else "replies"
  $('#reply-counter').text("#{num2str(posts)} #{label}")