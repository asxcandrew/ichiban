$ ->
  flash = $('.flash')
  if flash
    flash.delay(5000).hide("slide", { direction: "up" }, 200)

@flash = (type, text) ->
  $('.content').prepend("<div class='flash alert #{type}'>
                         #{text}
                         <a class='close' data-dismiss='alert' href='#'>×</a>
                       </div>")