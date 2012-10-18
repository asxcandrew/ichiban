options = { hard_wrap: true,
            filter_html: true,
            no_images: true,
            autolink: true,
            no_intraemphasis: true,
            fenced_code: true,
            gh_blockcode: true }
$MarkdownRenderer = Redcarpet::Markdown.new(Redcarpet::Render::HTML, options)