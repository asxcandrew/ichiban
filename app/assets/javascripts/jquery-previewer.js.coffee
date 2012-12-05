$.fn.previewer = (opts) ->
  defaultOpts =
    maxLength: 100

  opts = $.extend {}, defaultOpts, opts

  @.bind 'keyup', (e) ->
    $this = $(this)    
    $form = $(this).parents('form')
    
    $preview = $form.find(".preview")
    $previewBody = $preview.children(".body")

    converter = new Showdown.converter()

    if $this.val() != ''
      if $preview.is(":hidden")
        $preview.slideDown(quickly)
      $previewBody.html(converter.makeHtml($this.val()))
    else
      $preview.slideUp(quickly)

    true
