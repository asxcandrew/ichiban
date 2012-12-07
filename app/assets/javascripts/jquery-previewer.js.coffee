$.fn.previewer = (opts) ->
  defaultOpts =
    maxLength: 100

  opts = $.extend {}, defaultOpts, opts

  @.bind 'keyup', (e) ->
    $this = $(this)    
    $form = $(this).parents('form')
    
    $preview = $form.find(".preview")
    $previewHeader = $preview.children("header")
    $previewBody = $preview.children(".body")

    converter = new Showdown.converter()

    if $this.val() != ''
      if $preview.is(":hidden")
        $previewHeader.fadeIn(quickly)
        $preview.slideDown(quickly)
      $previewBody.html(converter.makeHtml($this.val()))
    else
      $previewHeader.fadeOut(quickly)
      $preview.slideUp(quickly)

    true
