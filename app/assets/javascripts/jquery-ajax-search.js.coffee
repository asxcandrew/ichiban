$.fn.ajaxSearch = (opts) ->
  defaultOpts =
    maxLength: 100

  opts = $.extend {}, defaultOpts, opts

  @.bindWithDelay 'keyup', (e) ->
    $this = $(this)
    keyword = $this.val()
    datalistID  = $this.attr('list')
    $datalist = $("##{datalistID}")
    $boardField = $("input[name='post[board_id]']")

    if e.keyCode == 13 # Enter
      $.getJSON "/boards/search/#{keyword}", (boards) ->
        $boardField.val(boards[0].id) unless boards.length == 0

    else if e.keyCode not in [9, 18, 37, 38, 39, 40] and not e.ctrlKey
      $.getJSON "/boards/search/#{keyword}", (boards) ->
        $datalist.empty()
        $.each boards, (i, board) ->
          status = if board.worksafe then "" else "NSFW"
          $datalist.append("<option value='#{board.name}' data-id='#{board.id}'>#{status}</option>")
        $boardField.val(boards[0].id) unless boards.length == 0
    true
  , 50
