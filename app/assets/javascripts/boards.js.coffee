$ ->
  $flash = $('.flash')
  if $flash
    $flash.delay(8000).hide("slide", { direction: "up" }, 200)

@flash = (type, text) ->
  closeButton = "<a class='close' data-dismiss='alert' href='#'><i class='icon-remove'></i></a>"
  $flash = $('.flash')
  if $flash.length == 0
    $('.content').prepend("<div class='flash alert #{type} style='display: none'>
                           #{text}
                           #{closeButton}
                         </div>")
    $flash = $('.flash')
  else
    $flash.attr('class', "flash #{type}")
    $flash.text(text)
    $flash.append(closeButton)

  $flash.stop(true, true).show "slide", { direction: "up" }, 200, () ->
    $flash.delay(8000).hide("slide", { direction: "up" }, 200)

@elementInViewport = (el) ->
  rect = el.getBoundingClientRect()
  return(
    rect.top >= 0 &&
    rect.left >= 0 &&
    rect.bottom <= window.innerHeight &&
    rect.right <= window.innerWidth)

@titleize = (text) ->
  return text[0].toUpperCase() + text.slice(1)