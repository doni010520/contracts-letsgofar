source 'https://rubygems.org'

ruby '3.2.2'

# Rails
gem 'rails', '~> 7.1.0'
gem 'pg', '~> 1.5'
gem 'puma', '~> 6.4'

# Assets
gem 'sprockets-rails'
gem 'importmap-rails'
gem 'turbo-rails'
gem 'stimulus-rails'
gem 'tailwindcss-rails'

# Email
gem 'resend', '~> 0.8'

# Security
gem 'bcrypt', '~> 3.1'

# JSON
gem 'jbuilder'

# PDF Generation
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'

# Background Jobs
gem 'sidekiq', '~> 7.0'
gem 'redis', '~> 5.0'

# Timezone
gem 'tzinfo-data', platforms: %i[windows jruby]

# Boot
gem 'bootsnap', require: false

group :development, :test do
  gem 'debug', platforms: %i[mri windows]
  gem 'dotenv-rails'
end

group :development do
  gem 'web-console'
end
