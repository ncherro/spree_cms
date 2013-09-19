Spree CMS
=========

Under development. Do not install!

Installation
------------

Add spree_cms to your Gemfile:

```ruby
gem 'spree_cms'
```

Bundle your dependencies and run the installation generator:

```shell
bundle
bundle exec rails g spree_cms:install
```

Testing
-------

Be sure to bundle your dependencies and then create a dummy test app for the specs to run against.

```shell
bundle
bundle exec rake test_app
bundle exec rspec spec
```

When testing your applications integration with this extension you may use it's factories.
Simply add this require statement to your spec_helper:

```ruby
require 'spree_cms/factories'
```

Copyright (c) 2013 ncherro, released under the New BSD License
