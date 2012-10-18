$ ->
  $flash = $('.flash')
  if $flash
    $flash.delay(5000).hide("slide", { direction: "down" }, 200)

@flash = (type, text) ->
  $flash = $('.flash')
  if $flash.length == 0
    $('.content').prepend("<div class='flash alert #{type} style='display: none'>
                           #{text}
                           <a class='close' data-dismiss='alert' href='#'>×</a>
                         </div>")
    $flash = $('.flash')
  else
    $flash.attr('class', "flash #{type}")
    $flash.text(text)

  $flash.show "slide", { direction: "down" }, 200, () ->
    $flash.delay(8000).hide("slide", { direction: "down" }, 200)

@elementInViewport = (el) ->
  rect = el.getBoundingClientRect()
  return(
    rect.top >= 0 &&
    rect.left >= 0 &&
    rect.bottom <= window.innerHeight &&
    rect.right <= window.innerWidth)
