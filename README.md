Spree CMS
=========

## Under development. Do not install!

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

Pull the CMS templates into your app (optional)

```shell
bundle exec rails g spree_cms:views
```

Run the rake task to pull Static Blocks into your database. Run this any time
you add / remove a template file from `app/views/cms/static_blocks` to keep
your database synced
```shell
bundle exec rake spree_cms:build:static_blocks
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
