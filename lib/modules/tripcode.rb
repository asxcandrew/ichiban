module Tripcode
  Forbidden_in_salt = ':;<=>?@[\]^_`'
  Forbidden_in_alternative = 'ABCDEFGabcdef'

  # Below is the canonical way to make 2ch style tripcodes.
  # I'm not sure who thought this was a good idea.
  def crypt_tripcode(input)
    # Password would be blank if only a hash was entered.
    unless input.blank?
      # Take second and third characters from input and appends 'H.'
      salt = (input + 'H.')[1..2]
      
      # Replace any characters not between . and z with .
      salt.gsub!(/[^a-zA-Z0-9\.]/, '.')
      
      # Replace any of the characters in :;<=>?@[\]^_` 
      # with the corresponding character from ABCDEFGabcdef.
      salt.tr!(Forbidden_in_salt, Forbidden_in_alternative)

      # Call crypt and returns the last 10 characters.
      input.crypt(salt)[-10..-1]
    end
  end
end