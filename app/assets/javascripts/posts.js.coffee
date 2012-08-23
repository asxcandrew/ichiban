$ ->
  $(document).on "click", ".reply-toggle", () ->
    toggleReply($(this).data('id'))

  $(document).on "click", ".delete-post", () ->
    deletePost($(this).data('id'))

  $('textarea').keydown () ->
    characters = $(this).val().length
    maxLength = $(this).attr('maxlength')
    percentange = Math.floor((characters / maxLength) * 100)

    console.log characters, maxLength, percentange

    form = $(this).parent()
    meter = $(form).find('.meter span')
    updateMeter(percentange, meter)

toggleReply = (id) ->
  reply = "##{id} .reply:first"
  $(reply).toggle(250)
  
  # Jump to the reply
  $('body').animate { scrollTop: $(reply).offset().top }, 250, () ->
    $("#{reply} input#post_name").focus()

deletePost = (id) ->
  tripcode = prompt("Enter your tripcode to delete post ##{id}.")

  if tripcode.length != 0
    $.post "/boards/test/#{id}", { _method: 'delete', tripcode }, 
      (response) ->
        if response.success
          $("##{id}").hide(250)
          flash("notice", response.message)
          if response.redirect
            console.log("REDIRECT")
        else
          flash("error", response.message)
  else
    flash("error", "No tripcode entered.")

updateMeter = (percentange, meter) ->
  $(meter).css("width", "#{percentange}%")