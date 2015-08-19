source 'https://rubygems.org'

gem 'devise'
# gem 'protected_attributes'
# Rails
gem 'rails', '4.2.1'
# gem 'rails-i18n'

# Server
gem 'kgio', '2.9.3'
gem 'unicorn'
gem 'simple_captcha2', require: 'simple_captcha'
# File uploads
gem 'carrierwave', '~> 0.10.0'
gem 'mini_magick', '4.2.1'

# Database
gem 'mysql2'

# Templating
gem 'slim'
gem 'redcarpet'           # Markdown.
gem 'color'
gem 'simple_form'
gem 'numbers_and_words'
gem 'kaminari'            # Pagination.
gem 'chronic'             # Humanized time parsing.

# Management
gem "rails-settings-cached", "0.4.1"

gem 'fog'
gem "fog-aws"

# Authentication
gem 'bcrypt-ruby'
gem 'cancancan'
gem "rolify"

group :development, :test do
  # gem 'therubyracer', :platforms => :ruby
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'database_cleaner'
end

#group :test do
#  gem 'watchr'
#  gem 'spork'
#
#  gem 'capybara'
#  gem 'capybara-webkit'
#  # Capybara webkit requires QT libraries
#  # sudo apt-get install libqt4-dev libqtwebkit-dev
#end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'bootstrap-sass'
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'compass-rails'
  gem 'font-awesome-sass-rails'

  gem 'uglifier'
end

group :production do
  # Logging
  # gem 'newrelic_rpm'
end
gem 'sprockets-rails', :require => 'sprockets/railtie'
gem 'jquery-rails'
