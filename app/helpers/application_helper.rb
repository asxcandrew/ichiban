module ApplicationHelper
  include IchibanAuthorization
  include MarkdownConverter

  def title
    text = @prefix ? "#{@prefix} :: NEXCHAN" : 'NEXCHAN'
    content_tag("title", text)
  end

  def pluralize_without_count(count, noun, text = nil)
    count == 1 ? "#{noun}#{text}" : "#{noun.pluralize}#{text}"
  end

  # Try to calculate time on the client side when you can.
  def human_time(time)
    tense = Time.now > time ? "ago" : "from now"
    "#{time_ago_in_words(time)} #{tense}.".capitalize
  end

  def body_tag(options = { class: ['no-js'] }, &block)
    options['data-controller'] = params[:controller]
    options['data-action'] = params[:action]

    # Nothing to see here.    
    options[:class] << "kidz-zone" if Date.today.month == 2 && Date.today.day == 29

    content_tag(:body, options) do
      capture(&block)
    end
  end
end