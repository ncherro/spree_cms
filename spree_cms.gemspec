# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_cms'
  s.version     = '2.0.4'
  s.summary     = 'Content Management System for Spree 2.0'
  s.description = 'Adds functionality for custom Pages, Menus, Menu Items, Templates and Blocks'
  s.authors = 'ncherro'
  s.email = 'ncherro@gmail.com'
  s.email = 'http://ncherro.com'
  s.required_ruby_version = '>= 1.9.3'

  #s.files       = `git ls-files`.split("\n")
  #s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")

  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 2.0'
  s.add_dependency 'ancestry', '~> 2.0.0'
  s.add_dependency 'nested_form', '~> 0.3.2'
  s.add_dependency 'simple_form', '~> 2.1.0'
  s.add_dependency 'rack-cache'
  s.add_dependency 'dragonfly', '~> 0.9.15'
  s.add_dependency 'tinymce-rails', '~> 4.0'

  s.add_development_dependency 'capybara', '~> 2.1'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner', '~> 1.0.1'
  s.add_development_dependency 'factory_girl', '~> 4.2'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'dalli'
  s.add_development_dependency 'rspec-rails',  '~> 2.13'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'quiet_assets', '~> 1.0.2'
end
