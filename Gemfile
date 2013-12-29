source 'https://rubygems.org'

gem 'rails', '3.2.13'

gem 'jquery-rails'
gem 'jquery-ui-rails'

gem 'haml-rails' # markup templates

gem 'rails_bootstrap_navbar', git: 'git://github.com/worldnamer/Rails-Bootstrap-Navbar' # Helper methods for Twitter Bootstrap navbars
gem "twitter-bootstrap-rails"
gem 'bootstrap-datepicker-rails'

gem 'angularjs-rails', '>= 1.2.0.rc1'
gem 'ngmin-rails'

gem 'devise' # Authentication

# Optimized JSON (Oj) for speeding up serialization
gem 'oj'

group :test do
  gem 'rspec-rails' # Unit testing
  gem 'database_cleaner', '~> 1.0.1' # JWLL: There's a bug in 1.1 that expects postgresql even if you're not using it
  gem 'debugger'
  gem 'timecop'
  gem 'factory_girl_rails', ">= 4.0" # Fixtures
end

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  gem 'uglifier', '>= 1.0.3'

  gem "therubyracer"
  gem "less-rails" # LESS stylesheets

  gem "rickshaw_rails" # Rickshaw for charts
end

group :development do
  gem 'sqlite3'
end

group :production do
  gem 'pg'
end

