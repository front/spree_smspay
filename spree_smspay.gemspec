# encoding: UTF-8
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'spree_smspay/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_smspay'
  s.version     = SpreeSmspay::VERSION
  s.summary     = 'Adds Smspay as a Payment Method to Spree Commerce'
  s.description = 'SMSpay: A mobile friendly payment method implemented in Spree Commerce'
  s.required_ruby_version = '>= 2.1.0'

  s.authors   = ['Segi Henggana']
  s.email     = 'henggana7@gmail.com'
  s.homepage  = 'https://rubygems.org/gems/spree_smspay'

  s.files        = `git ls-files`.split("\n")
  s.test_files   = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 3.0'
  s.add_dependency 'faraday'
  s.add_dependency 'faraday_middleware'

  s.add_development_dependency 'capybara', '~> 2.4'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl', '~> 4.5'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 3.1'
  s.add_development_dependency 'sass-rails', '~> 4.0.2'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'simplecov-rcov'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'pry'
end
