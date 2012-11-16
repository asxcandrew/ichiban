$ ->
  $(".users").on "click", ".delete-user", (e) ->
    e.preventDefault()
    deleteUser($(this).data('id'))

deleteUser = (id) ->
  params = 
    _method: 'delete'

  email = $("##{id} .email").text()
  userResponse = confirm("Do you really want to delete #{email}")

  if userResponse
   $.ajax
    type: 'POST'
    url: "/users/#{id}"
    data: params
    success: (response) ->
      $("##{id}").hide quickly, () ->
        $(this).empty().remove()
        updateCounter('user', '.users .user')
    complete: (response) ->
      flash($.parseJSON(response.responseText).flash)