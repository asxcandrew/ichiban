$.fn.limiter = (opts) ->
  defaultOpts =
    maxLength: 100

  opts = $.extend {}, defaultOpts, opts

  @.keydown (e) ->
    $this = $(this)
    val = $this.val()
    characters = val.length

    if opts.maxLength <= characters and e.keyCode not in [8, 9] and not e.ctrlKey
      do e.preventDefault

    percentage = Math.floor((characters / opts.maxLength) * 100)

    form = $(this).parent().parent()
    meter = $(form).find('.meter span')
    updateMeter(percentage, meter)

    true

  @.bind "keyup change", (e) ->
    $this = $(this)
    val = $this.val()

    characters = val.length

    if characters > opts.maxLength
      $this.val(val.substring(0, opts.maxLength))
      characters = opts.maxLength

    true