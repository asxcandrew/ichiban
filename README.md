# Ichiban
###*Modern Imageboard Software*

## What's this all about?
Every imageboard software has attempted to clone its predecessor. Futaba, Wakaba, Kusaba; all of these are terrible. It's time for something better than just a clone.

# Developer Features
* Written with the beautiful web framework, Ruby on Rails.
* SASS.
* Works out of the box.
* Cloud friendly.
* Posts via JSON.
* Test driven.
* Built with ActiveRecord for easy database abstraction.
* Image hosting via Cloudinary

# User Features
* Markdown formatting.
* Post Reporting.
* Inline quoting.
* Tripcodes/Secure Tripcodes
* Modern UI while retaining the feel of an imageboard.
* Built in "4chan X"-esq enhancements:
  * Post hiding.
  * Image expansion.
  * Inline reply fields. 
* Permanent thread archiving.

# Adminstration/Moderation
* Inline funcitionality:
  * Editing posts.
  * Quick banning.
* Regex spam prevention.
* Image deduplication.
* Optional reCAPTCHA.

# Thread Architecture
Traditionally, imageboards rely on quote anchors to reply to posts. A thread is simply a series of replies to a post in Ichiban, saving users from having to re-read posts.

# Setup
Ichiban is a Rails app; we don't do anything fancy here. Things will go better for you if Heroku and Cloudinary are used.
## Requirements
* Some *nix variant. I recommend Ubuntu Server or a Debian derivative. (God help you if you're on Gentoo.)
* Ruby 1.9.3+, preferably using RVM; Ichiban uses the new symbol syntax (e.g. foo: "bar").
* Bundler; See Gemfile for gem dependecies.
* Relevent database dependecies (Postgres, MySQL, etc). I recommend Postgres though MySQL should be fine.


# License
Ichiban by Eric Wright is licensed under a Creative Commons Attribution-ShareAlike 3.0 Unported License.
Based on a work at https://github.com/ericwright90/ichiban.