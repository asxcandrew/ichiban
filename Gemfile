source 'https://rubygems.org'

# Rails
gem 'rails', '3.2.11'
gem 'rails-i18n'

# Server
gem 'unicorn'

# File uploads
gem 'carrierwave'
gem 'mini_magick'

# Database
gem 'pg'

# Templating
gem 'slim'
gem 'redcarpet'           # Markdown.
gem 'color'
gem 'simple_form'
gem 'numbers_and_words'
gem 'kaminari'            # Pagination.
gem 'chronic'             # Humanized time parsing.

# Management
gem "rails-settings-cached"

# Authentication
gem 'bcrypt-ruby'
gem 'cancan'
gem 'simple_roles'

group :development, :test do
  gem 'therubyracer', :platforms => :ruby
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
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'compass-rails'
  gem 'font-awesome-sass-rails'

  gem 'uglifier', '>= 1.0.3'
end

group :production do
  # Logging
  # gem 'newrelic_rpm'
end

gem 'jquery-rails'
