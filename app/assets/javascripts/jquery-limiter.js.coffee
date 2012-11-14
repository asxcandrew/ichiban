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

    $form = $(this).parents('form')
    $submitField = $form.find('input[type=submit]')
    $uploadField = $form.find('input[type=file]')
    $meter = $form.find('.meter span')

    updateMeter(percentage, $meter)
    
    # A comment or upload is required for replying.
    if $form.data('posttype') == 'reply'
      if characters > 1
        $($submitField).prop("disabled", false)
      else
        $($submitField).prop("disabled", true)

    true

  @.bind "keyup change", (e) ->
    $this = $(this)
    val = $this.val()

    characters = val.length

    if characters > opts.maxLength
      $this.val(val.substring(0, opts.maxLength))
      characters = opts.maxLength

    true