$ ->
  # An upload is required for creating a new post.
  $uploadField = $(".new_post input:file")
  $submitField = $(".new_post input:submit")
  checkUploadField($uploadField.attr('value'), $submitField)

  $uploadField.change (e) ->
    $submitField = $(this).parents('.new_post').find("input[type='submit']")
    checkUploadField(e.target.value, $submitField)

  # The body limitation is also validated in
  # post model.
  $('textarea').limiter(maxLength: 800)

  $(window.controls).on "click", ".reply-toggle", (e) ->
    e.preventDefault()
    toggleReply($(this).data('id'))

  $("figure").on "click", "a", (e) ->
    e.preventDefault()
    toggleImageExpansion($(this))

  $(".new_post #board").ajaxSearch()

toggleImageExpansion = ($link) ->
  # Hide the animation element
  $link.toggleClass('expanded')

  image = $link.children("img")
  max_width = $link.parents('article').width()

  # Get sources
  oldSource = image.attr('src')
  newSource = image.data('toggle')

  # Store old source
  image.data('toggle': oldSource)

  # Add loading decorator.
  image.addClass('loading')

  image.css('max-width': max_width)
  image.attr('src': newSource).one('load', () ->
    image.removeClass('loading'))

toggleReply = (id) ->
  reply = "##{id} .reply:first"
  $(reply).toggle(window.animationDuration)
  
  # Jump to the reply
  if $(reply).is(':visible')
    $('body').animate { scrollTop: $("##{id}").offset().top }, 200, () ->
      $("#{reply} textarea:first").focus()

@updateMeter = (percentage, meter) ->
  percentage = Math.min(percentage, 100)
  $(meter).css("width", "#{percentage}%")

@updateReplyCounter = (id) ->
  id = $('.parent').attr('id')
  $.getJSON "/posts/#{id}.json", (post) ->
    post.replies

    label = if post.replies == 1 then "reply" else "replies"
    # wordy_number = num2str(post.replies)
    $("##{id} .replies").text("#{post.replies} #{label}")

@checkUploadField = (value, submitField) ->
  if value == ''
    $(submitField).prop("disabled", true)
  else
    $(submitField).prop("disabled", false)