require "spree/core"
require "nested_form"
require "simple_form"
require "ancestry"
require "rack/cache"
require "dragonfly"
require "tinymce-rails"

module SpreeCms
  class Engine < Rails::Engine

    #isolate_namespace Spree
    # * if isolated, helpers won't work unless we add this line to the parent
    # app's ApplicationController
    #
    # helper Spree::CmsHelper

    engine_name 'spree_cms'

    config.autoload_paths += %W(#{config.root}/lib #{config.root}/lib/spree)

    initializer "precompile", :group => :all do |app|
      app.config.assets.precompile << "tinymce/plugins/cms_image/plugin.js"
      app.config.assets.precompile << "admin/spree_cms_image.js"
      app.config.assets.precompile << "admin/spree_cms_file.js"
    end

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    # load decorators
    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare &method(:activate).to_proc
  end
end
