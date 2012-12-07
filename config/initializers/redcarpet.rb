require 'redcarpet/render_strip'

options = { hard_wrap: true,
            filter_html: true,
            no_images: true,
            autolink: true,
            no_intraemphasis: true,
            fenced_code: true,
            safe_links_only: true,
            strikethrough: true,
            superscript: true,
            gh_blockcode: true }
$MarkdownRenderer = Redcarpet::Markdown.new(Redcarpet::Render::HTML, options)
$MarkdownStripper = Redcarpet::Markdown.new(Redcarpet::Render::StripDown, space_after_headers: true)