# encoding: utf-8
module TripcodesHelper
  def link_to_tripcode(tripcode, &block)
    path = url_for(controller: 'tripcodes', action: 'show', tripcode: tripcode)
    link_to(path, title: I18n.t('posts.tripcodes.browse'), &block)
  end
end
