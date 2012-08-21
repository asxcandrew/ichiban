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
  if confirm("Are you sure you want to delete post ##{id}?")
    $.post "/boards/test/#{id}", { _method: 'delete' }, (response) ->
      if response.success
        $("##{id}").hide(250)
        flash("notice", response.message)
      else
        flash("warning", response.message)

updateMeter = (percentange, meter) ->
  $(meter).css("width", "#{percentange}%")