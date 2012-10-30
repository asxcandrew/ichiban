# Ichiban
### *Modern Imageboard Software*

## What's this all about?
Every imageboard software has attempted to clone its predecessor. Futaba, Wakaba, Kusaba; all of these are terrible. It's time for something better than just a clone.

Ichiban is an imageboard designed to retain the feel of its predecessors while fixing the usability issues that have plagued them. The layout attempts to reduce unnecessary distractions and exemplify user content. Ichiban acts more like a board platform than a single imageboard. Users are free to make their own boards and delegate moderator status accordingly. 

# Local Setup
Ichiban is a Ruby on Rails application so the setup is minimal.
## Requirements
* Some *nix variant or OSX. I recommend Ubuntu Server or a Debian derivative.
* Ruby 1.9.3+, preferably using [RVM](https://rvm.io/).
* [Heroku Toolbelt](https://toolbelt.heroku.com/) (for production use.)
* Bundler; See Gemfile for gem dependencies.
* Relevent database dependencies (Postgres, MySQL, etc). I recommend Postgres though MySQL should be fine.

Clone the repository and run `bundle`. You can use `bundle --without test` to omit any testing gems as they require additional libraries. The Ichiban documentation assumes that you prepend `bundle exec` to your commands. I recommend an alias such as `alias be="bundle exec"` in your `.bashrc`/`.zshrc`.

Run `rake db:setup`. This rake command will load the database schema and seed any necessary defaults.

Make sure you're able to create a database user named 'ichiban'. Postgres on Ubuntu can be a little overzealous and prevent local users from accessing databases without credentials. You can fix the issue by editing `/etc/postgresql/9.1/main/pg_hba.conf` and change the `METHOD` column from whatever is listed to `trust`; **this configuration is only acceptable in a development environment.**

## Configuration
Make sure to edit your `cloudinary.yml` file with your [account credentials](https://cloudinary.com/users/register/free). The free tier should be more than enough for development purposes.

You should be all set to run Ichiban with `be rails s`.

# Production Setup
While there is no reason you cannot setup Ichiban to run on Passenger, the software is built to live on Heroku. Image hosting is done through [Cloudinary](https://github.com/cloudinary/cloudinary_gem) but uses [Carrierwave](https://github.com/jnicklas/carrierwave) to create image models. Carrierwave can be configured to store images locally or even resize images and send them off to S3, though that configuration is outside the scope of this guide.

## Heroku
Assuming you have an account and your credentials setup, setup is as easy as creating a new Heroku app. Make sure to add the Postgres and Cloudinary addons at the Heroku control panel or with the Heroku toolbelt. I recommend the Postgres Backup and Log Entries addons too.

### Configuration
Ichiban expects a few environment variables to run in production mode. You can add them on Heroku with the `heroku config:add` command.
#### Secret Keys
Your cookie token should be **at least 30 random characters**. Changing the cookie token will invalidate any existing Ichiban cookies.

`heroku config:add SECRET_COOKIE_TOKEN=YOUR_SECRET_KEY`

Your secure tripcode salt should follow the same rules. Changing the secure tripcode salt will alter all future secure tripcodes.

`heroku config:add SECURE_TRIPCODE_SALT=YOUR_SECURE_TRIPCODE_SALT`

# Contributing
File an issue report on GitHub if your unable to submit a Pull Request yourself.

## Pull Requests
Make sure your code matches the [style guide](https://github.com/bbatsov/ruby-style-guide).
Ichiban uses the new symbol syntax when possible except when assigning a symbol to another symbol (e.g. `foo: :bar`).
I encourage clarity over fanciness; avoid awkward one-liners and unclear assignment.

# Features

## For Users
* Markdown formatting.
* Post Reporting.
* Tripcodes/Secure Tripcodes
* Built in "4chan X"-esq enhancements:
  * Post hiding.
  * Image expansion.
* Permanent thread archiving.

# Adminstration/Moderation
* Inline funcitionality:
  * Editable posts.
  * Quick banning.
* Image deduplication via Cloudinary.
* Optional reCAPTCHA.
* Reports:
 * Prevents duplicates.
 * Settable limit per IP.

# Thread Architecture
Traditionally, imageboards rely on quote anchors to reply to posts. In Ichiban, a thread is simply a series of replies to a post. A post is an *ancestor* if it has started a thread. While any direct reply is known as a *child*, any reply to an ancestor or one of its children are known as *descendants*. Any reply to a post has *parent*.

# License
Ichiban by Eric Wright is licensed under a Creative Commons Attribution-ShareAlike 3.0 Unported License.
Based on a work at https://github.com/ericwright90/ichiban.