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
    $.post "/users/#{id}", params, (response) ->
      if response.success
        flash("notice", response.message)
      else
        flash("error", response.message)