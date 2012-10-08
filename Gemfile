source 'https://rubygems.org'

# Rails
gem 'rails', '3.2.8'

# Server
gem 'unicorn'

# File uploads
gem 'carrierwave'
gem 'cloudinary'

# Database
gem 'pg'

# Cloud stuff
gem 'heroku'

# Templating
gem 'slim'
gem 'redcarpet' # Markdown
gem 'color'
gem 'simple_form'
gem 'numbers_and_words'
gem 'kaminari' # Pagination

# Management
gem "rails-settings-cached"

# Authentication
gem 'bcrypt-ruby'
gem 'cancan'
gem 'simple_roles' 

group :development, :test do
  gem 'pry'
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'nyan-cat-formatter', '0.0.7' # Because I said so.
  
  gem 'watchr'
  gem 'spork'

  gem 'capybara'
  gem 'capybara-webkit'
  # Capybara webkit requires QT libraries
  # sudo apt-get install libqt4-dev libqtwebkit-dev
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'compass-rails'
  gem 'font-awesome-sass-rails'
  gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
