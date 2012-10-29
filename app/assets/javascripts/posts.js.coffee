$ ->
  $imageField = $("#new_post input:file")
  checkImageField($imageField.attr('value'))

  $imageField.change (e) ->
    checkImageField(e.target.value)

  updateReplyCounter()
  # The body limitation is also validated in
  # post model.
  $('textarea').limiter(maxLength: 800)

  $(window.controls).on "click", ".reply-toggle", (e) ->
    e.preventDefault()
    toggleReply($(this).data('id'))

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
  image.addClass('loading')
  image.attr('src': newSource).one('load', () ->
    if image.css('max-width') == 'none'
      image.css('max-width': '100%')
    else if image.css('max-width') == '100%'
      image.css('max-width': 'none')
    image.removeClass('loading'))

toggleReply = (id) ->
  reply = "##{id} .reply:first"
  $(reply).toggle(window.animationDuration)
  
  # Jump to the reply
  $('body').animate { scrollTop: $(reply).offset().top }, 200, () ->
    $("#{reply} textarea:first").focus()

@updateMeter = (percentage, meter) ->
  percentage = Math.min(percentage, 100)
  $(meter).css("width", "#{percentage}%")

updateReplyCounter = () ->
  posts = $('.parent .post').length
  label = if posts == 1 then "reply" else "replies"
  wordy_number = num2str(posts)
  $('.reply-counter').text("#{titleize(wordy_number)} #{label}")

checkImageField = (value) ->
  if value == ''
    $("#new_post input:submit").prop("disabled", true)
  else
    $("#new_post input:submit").prop("disabled", false)