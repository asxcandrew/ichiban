$ ->
  $(document).on "click", ".reply-toggle", (e) ->
    e.preventDefault()
    toggleReply($(this).data('id'))
  
  # The body limitation is also validated in
  # post model.
  $('textarea').limiter(maxLength: 800)

  controls = '.post footer'

  $(controls).on "click", ".delete-post-with-tripcode", (e) ->
    e.preventDefault()
    deletePost($(this).data('id'), { askForTripcode: true })

  $(controls).on "click", ".delete-post", (e) ->
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
  $post = $(id)
  params = 
    _method: 'create',
    suspension:
      post_id: id
      directory: $post.data('directory')
      reason: prompt("Reason for suspension?")

  $.post "/suspensions/", params, (response) ->
    if response.success
      flash("notice", response.message)
    else
      flash("error", response.message)


@updateMeter = (percentage, meter) ->
  percentage = Math.min(percentage, 100)
  $(meter).css("width", "#{percentage}%")