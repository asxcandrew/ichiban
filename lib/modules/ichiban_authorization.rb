module IchibanAuthorization
  # While CanCan shows if a user is authorized to use any of the RESTful actions
  # it cannot understand the concept of ownership. This is where IchibanAuthorization fits the bill.
  # We first check if the user is authorized by CanCan. Then we see if they actually 'own' the object in question.


  def check_if_user?(authorization, object)
    if authorization && object
      class_name = object.class.to_s.pluralize.underscore.to_sym
      @current_user.send(class_name).include?(object)
    else
      false
    end
  end

  # e.g. check_if_user_can!(:destroy, Post, @post)
  #      check_if_user_can!(:create, Suspension, @suspension.board)
  # TODO: The error messages aren't very helpful if the object's class is different from the authorization_class
  def check_if_user_can!(action, authorization_class, object)
    # It's always fun to this.
    denial_message  = if object.nil? || object.id.nil?
                        I18n.t('authorization.not_authorized_vague', 
                               action: action.to_s, 
                               authorization_class: authorization_class.to_s.pluralize.downcase)
                      else
                        I18n.t('authorization.not_authorized_specific', 
                               action: action.to_s, 
                               auth_object: object.class.to_s.downcase, 
                               auth_object_id: object.id)
                      end

    if can?(action, authorization_class) && object
      # Transmogrify the object's class into something we can work with.
      class_name = object.class.to_s.pluralize.underscore.to_sym

      # This user better own the object. Otherwise, they get denied.
      @current_user.send(class_name).include?(object) ? true : raise(CanCan::AccessDenied, denial_message)
    else
      # Seems that the user was denied by CanCan or the object in question was nil.
      raise CanCan::AccessDenied, denial_message
    end
  end
end