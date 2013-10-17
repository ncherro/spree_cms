# Spree CMS

## Under development. Do not install!


## Compatibility

Tested on Spree 2.0.x


## Installation

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


## About

This extension adds a Content Management System to your Spree site. Complete with:

- Layouts > Regions > Blocks
- Menus with nestable Menu Items
- Pages, belonging to Menu Items, are editable using a WYSIWYG editor
- WYSIWYG image uploader
- Slideshow, Menu, Custom HTML, and Static blocks

See the wiki for more info.


## Testing

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


## Contributing


## License

Copyright (c) 2013 ncherro, released under the New BSD License
