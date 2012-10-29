module TripcodesHelper
  def link_to_tripcode(*text, tripcode)
    text = text.empty? ? "!#{tripcode}" : text.to_sentence
    link_to(text, 'tripcodes_path(tripcode)', title: "Browse posts made by #{tripcode}")
  end
end
