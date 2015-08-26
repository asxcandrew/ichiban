page = 1
lastPage = false
loading = false
teaserTruncate = 40

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
    path += "?html_newlines=true"

    $.ajax
      url: path
      type: "get"
      success: (response) ->
        console.log "Showcases on page #{page}: ", response
        if response.length == 0
          lastPage = true
          # flash(type: 'notice', message: "You've hit the end of the page.")
          return true
        
        newShowcases = ""
        $(response).each (i, post) ->
          if post.body == "" 
            teaser = "View Thread" 
          else if post.body.length > teaserTruncate
            # Don't want to truncate on a space.
            teaserTruncate-- if post.body.charAt(teaserTruncate - 1) == ' '
            teaser = post.body.substring(0,teaserTruncate) + '...'
          else
            teaser = post.body

          newShowcases +=
            "<div id='#{post.id}' class='showcase'>
              <a href='/posts/#{post.id}'>"

          unless post.subject == ""
            newShowcases += 
              "<header class='banner'>#{post.subject}</header>"

          newShowcases +=
              "<img width='300px' src='#{post.image.asset.showcase.url}' />
              <footer class='teaser'><div class='body'>#{teaser}</div></footer>
            </a>
          </div>"
        showcases.isotope "insert", $(newShowcases), () ->
          showcases.isotope('reLayout')
          loading = false

@nearBottomOfPage = ->
  $(window).scrollTop() > $(document).height() - $(window).height() - 450
