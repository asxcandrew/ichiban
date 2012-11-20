# encoding: utf-8
module Tripcode
  def generate_tripcode_v2(passphrase)
    unless passphrase.nil? || passphrase.blank?
      Digest::SHA2.hexdigest(SECURE_TRIPCODE_SALT + passphrase)[-6..-1]
    end
  end

  # Below is the canonical way to make 2ch style tripcodes.
  # I'm not sure who thought this was a good idea.
  def generate_tripcode(passphrase, options = {})
    forbidden_in_salt = ':;<=>?@[\]^_`'
    forbidden_in_alternative = 'ABCDEFGabcdef'

    unless passphrase.nil? || passphrase.blank?
      input = passphrase.clone

      # Secure tripcodes translate any characters with their corresponding match
      # in the secure tripcode salt.
      if options[:secure]
        input.tr!('a-zA-Z0-9', SECURE_TRIPCODE_SALT)
      end

      # Take second and third characters from input and appends 'H.'
      salt = (input + 'H.')[1..2]
      
      # Replace any characters not between . and z with .
      salt.gsub!(/[^a-zA-Z0-9\.]/, '.')
      
      # Replace any of the characters in :;<=>?@[\]^_` 
      # with the corresponding character from ABCDEFGabcdef.
      salt.tr!(forbidden_in_salt, forbidden_in_alternative)

      # Call crypt and return the last 10 characters.
      return input.crypt(salt)[-10..-1]
    end
  end
  
  TRIPCODE_SYMBOLS = [
    '☸',
    '☉',
    '☭',
    '✥',
    '✈',
    '☄',
    '✬',
    '😃',
    '✱',
    '😁',
    '☀',
    '❃',
    '✯',
    '☁',
    '☯',
    '😊',
    '☢',
    '⚔',
    '❖',
    '✶',
    '✳',
    '😄',
    '❄',
    '♪',
    '😉',
    '✜',
    '★',
    '😰',
    '✙',
    '😞',
    '☣',
    '❤',
    '😌',
    '😓',
    '➶',
    '😖',
    '✣',
    '❄',
    '✫',
    '❆',
    '❦',
    '☃',
    '♫',
    '😜',
    '🐱',
    '☘',
    '⚡',
    '⚠',
    '☠',
    '✠',
    '😚',
    '☮',
    '☕',
    '❉',
    '✦',
    '✺',
    '❂',
    '♬',
    '❁',
    '☂',
    '❀',
    '❢',
    '☆',
    '✲',
    '✪',
    '✩',
    '⚝',
    '✸',
    '✭',
    '✵',
    '❋',
    '❈',
    '😒',
    '♩',
    '✾',
    '❊',
    '✼',
    '✿',
    '✽',
    '🐭',
    '⚒',
    '✤',
    '♾',
    '😝']

end