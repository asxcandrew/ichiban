@flash = (type, text) ->
  $('.content').prepend("<div class='flash alert #{type}'>
                         #{text}
                         <a class='close' data-dismiss='alert' href='#'>×</a>
                       </div>")