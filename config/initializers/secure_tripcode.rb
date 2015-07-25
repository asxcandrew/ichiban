# This is your secure tripcode salt. Changing the salt will alter future secure tripcodes!

SECURE_TRIPCODE_SALT = Rails.env.production? ? Rails.application.secrets.secure_tripcode_salt : "34290judcd0i03jc02d23rfa323dqc3era45zaa3fdae2vr6h65gwe4t2"

if SECURE_TRIPCODE_SALT.nil? || SECURE_TRIPCODE_SALT.blank?
  puts "Secure tripcode seed not set!"
  exit
end
