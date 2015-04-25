source 'https://rubygems.org'
ruby '2.1.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.4'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# For creating Users
gem "devise", "~> 3.2.2"

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

# handles browser security policy headers - used in application controller
gem 'secure_headers' 

# Bootstrap for styling
gem "bootstrap-sass", "~> 3.1.1.0"

# for image uploads with ImageMagick
gem 'paperclip', '~> 4.2'

# # for amazon s3 file storage
gem 'aws-sdk', '< 2.0'

# jQuery include file
gem 'masonry-rails', '~> 0.2.0'

# rename ids in urls
gem 'friendly_id', '~> 5.0.0'

# # In place editing like medium.com
# gem 'medium-editor-rails'

# font awesome icons
gem 'font-awesome-sass', '~> 4.3.0'

# mathjax for rendering math symbols
gem 'mathjax-rails', '~> 2.5.1'

group :development, :test do
	# Use sqlite3 as the database for Active Record
	gem 'sqlite3'
end

group :production do
	gem 'pg'
	gem 'unicorn'
 	gem 'unicorn-worker-killer'
 	gem 'exception_notification'
	gem 'rails_12factor'
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end
