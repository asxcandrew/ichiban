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

  # Isotope
  $(window).load () ->
    showcases.isotope
      itemSelector: '.showcase'
      masonry:
        columnWidth: colW
        columns: null
        gutterWidth: 10
    ,() ->
      # Avoid awkward flashes of content.
      showcases.css('visibility', 'visible')
      # Fix height shadow issues.
      height = showcases.height() + 25
      showcases.height(height)

@elementInViewport = (el) ->
  rect = el.getBoundingClientRect()
  return(
    rect.top >= 0 &&
    rect.left >= 0 &&
    rect.bottom <= window.innerHeight &&
    rect.right <= window.innerWidth)

@titleize = (text) ->
  return text[0].toUpperCase() + text.slice(1)

@updateCounter = (name, element) ->
  total = $(element).length
  label = if 1 == total then name else (name + 's')
  $("##{name}-counter").text("#{total} #{titleize(label)}")

@scrollTo = (selector, offset, callback) ->
  offset = 0 if offset == undefined
  $('body').animate { scrollTop: ($(selector).offset().top + offset) }, quickly, () ->
    callback()
