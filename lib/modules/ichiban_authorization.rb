module IchibanAuthorization
  def check_if_user?(authorization, object)
    if authorization && object
      class_name = object.class.to_s.pluralize.underscore.to_sym
      @current_user.send(class_name).include?(object)
    else
      false
    end
  end
end