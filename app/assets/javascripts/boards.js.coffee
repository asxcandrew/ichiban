$ ->
  window.showcases = $(".showcases")
  colW = 5
  $header = $('.site-header')

  $(window).scroll (e) ->
    if $header.offset().top != 0
      if !$header.hasClass('inset')
        $header.addClass('inset')
    else
      $header.removeClass('inset')

  # Set humanized times.
  $('time').timeago()

  # Isotope
  $(window).load () ->
    showcases.isotope
      itemSelector: '.showcase'
      masonry:
        columnWidth: colW
        columns: null
        gutterWidth: 10
    ,() ->
      # Fix height shadow issues.
      height = showcases.height() + 25
      showcases.height(height)




  $flash = $('.flash')
  if $flash
    type = $flash.data('type')
    $flash.delay(flashDelays[type]).hide("slide", { direction: "up" }, 200)

@flash = (flashData) ->
  closeButton = "<a class='close' data-dismiss='alert' href='#'><i class='icon-remove'></i></a>"
  $flash = $('.flash')

  if $flash.length == 0
    # No flash on the page. Better make one.
    $('.content').prepend("<div data-type=#{flashData.type} class='flash alert style='display: none'>
                             #{flashData.message}
                             #{closeButton}
                           </div>")
    $flash = $('.flash')
  else
    # Flash already exists, better replace it's contents.
    $flash.attr('data-type', flashData.type)
    $flash.text(flashData.message)
    $flash.append(closeButton)

  $flash.stop(true, true).show "slide", { direction: "up" }, 200, () ->
    $flash.delay(flashDelays[flashData.type]).hide("slide", { direction: "up" }, 200)

@elementInViewport = (el) ->
  rect = el.getBoundingClientRect()
  return(
    rect.top >= 0 &&
    rect.left >= 0 &&
    rect.bottom <= window.innerHeight &&
    rect.right <= window.innerWidth)

@titleize = (text) ->
  return text[0].toUpperCase() + text.slice(1)

@flashDelays = { notice: 6000, warning: 7000, error: 9000 }

@updateCounter = (name, element) ->
  total = $(element).length
  label = if 1 == total then name else (name + 's')
  $("##{name}-counter").text("#{total} #{titleize(label)}")

@scrollTo = (selector, offset, callback) ->
  offset = 0 if offset == undefined
  $('body').animate { scrollTop: ($(selector).offset().top + offset) }, quickly, () ->
    callback()
