module TripcodesHelper
  def link_to_tripcode(tripcode, options = {})
    title = "Browse posts made with this " + (options[:secure] ? 'secure ' : '') + "tripcode."

    # Append the decoractor.
    decorated_tripcode = (options[:secure] ? '!!' : '!') + tripcode

    path = url_for(controller: 'tripcodes', action: 'show', secure: options[:secure], tripcode: tripcode)
    link_to(decorated_tripcode, path, title: title)
  end
end
