$.fn.limiter = (opts) ->
  defaultOpts =
    maxLength: 100

  opts = $.extend {}, defaultOpts, opts

  @.keydown (e) ->
    $this = $(this)
    val = $this.val()
    characters = val.length
    maxLength = $this.attr('maxlength')

    $form = $(this).parents('form')
    $submitField = $form.find('input[type=submit]')
    $uploadField = $form.find('input[type=file]')
    $meter = $form.find('.meter span')

    if maxLength <= characters and e.keyCode not in [8, 9, 18, 37, 38, 39, 40] and not e.ctrlKey
      do e.preventDefault

    percentage = Math.floor((characters / maxLength) * 100)


    updateMeter(percentage, $meter)
    
    # TODO: It would be nice to split this feature into its own file.
    # A comment or upload is required for replying.
    if $form.data('posttype') == 'reply'
      if characters > 1
        $uploadField.prop("required", false)
      else
        $uploadField.prop("required", true)

    true

  @.bind "keyup change", (e) ->
    $this = $(this)
    val = $this.val()
    maxLength = $this.attr('maxlength')

    characters = val.length

    if characters > maxLength
      $this.val(val.substring(0, opts.maxLength))
      characters = maxLength

    true