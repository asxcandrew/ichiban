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

  page = 1
  lastPage = false
  loading = false

  $(window).scroll ->
    if lastPage || loading
      return
    
    # REFACTOR: Not sure how to prevent this from running on every page just yet. This will do for now.
    controller = $('body').data('controller')
    action = $('body').data('action')

    if controller == 'boards' and (action == "show" or action == "index") && nearBottomOfPage()
      loading = true
      page++
      board = showcases.data('directory')
      path = if board then "/boards/#{board}/#{page}.json" else "/boards/#{page}.json"

      $.ajax
        url: path
        type: "get"
        success: (response) ->
          console.log "Got this: ", response
          if response.length == 0
            lastPage = true
            flash(type: 'notice', message: "You've hit the end of the page.")
            return true
          
          newShowcases = ""
          $(response).each (i, post) ->
            if post.body == "" 
              teaser = "View Thread" 
            else if post.body > 40
                teaser = post.body.substring(0,40) + '...'
            else
              teaser = post.body

            newShowcases +=
              "<div id='#{post.id}' class='showcase'>
                <a href='/posts/#{post.id}'>
                  <header class='banner'>#{post.subject}</header>
                  <img width='300px' src='#{post.image.asset.showcase.url}' />
                  <footer class='teaser'>#{teaser}</footer>
                </a>
              </div>"
          showcases.isotope "insert", $(newShowcases), () ->
            showcases.isotope('reLayout')
            loading = false
            


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

@nearBottomOfPage = ->
  $(window).scrollTop() > $(document).height() - $(window).height() - 450
