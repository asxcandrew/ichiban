$ ->
  $flash = $('.flash')
  if $flash
    $flash.delay(5000).hide("slide", { direction: "down" }, 200)

@flash = (type, text) ->
  $('.content').prepend("<div class='flash alert #{type} style='display: none'>
                         #{text}
                         <a class='close' data-dismiss='alert' href='#'>×</a>
                       </div>")
  $flash = $('.flash')

  $flash.show("slide", { direction: "down" }, 200)
  $flash.delay(5000).hide("slide", { direction: "down" }, 200)
