module SpreeCms
  module Generators
    class InstallGenerator < Rails::Generators::Base

      class_option :auto_run_migrations, type: :boolean, default: false

      def add_javascripts
        append_file 'app/assets/javascripts/store/all.js', "//= require store/spree_cms\n"
        append_file 'app/assets/javascripts/admin/all.js', "//= require admin/spree_cms\n"
      end

      def add_stylesheets
        inject_into_file 'app/assets/stylesheets/store/all.css', " *= require store/spree_cms\n", :before => /\*\//, :verbose => true
        inject_into_file 'app/assets/stylesheets/admin/all.css', " *= require admin/spree_cms\n", :before => /\*\//, :verbose => true
      end

      def add_migrations
        run 'bundle exec rake railties:install:migrations FROM=spree_cms'
      end

      def add_seeds
        prepend_file 'db/seeds.rb', "SpreeCms::Engine.load_seed if defined?(SpreeCms)"
      end

      def run_simple_form_generator
        run 'bundle exec rails g simple_form:install'
        gsub_file 'config/initializers/simple_form.rb', /:class => :hint/, ':class => :info'
        gsub_file 'config/initializers/simple_form.rb', /# config.default_input_size = 50/, 'config.default_input_size = 0'
        gsub_file 'config/initializers/simple_form.rb', /b.use :error, :wrap_with => { :tag => :span, :class => :error }/, 'b.use :error, :wrap_with => { :tag => :span, :class => :formError }'
        gsub_file 'config/initializers/simple_form.rb', /:error_class => :field_with_errors/, ':error_class => :withError'
        gsub_file 'config/initializers/simple_form.rb', /config.wrappers :default, :class => :input,/, 'config.wrappers :default, :class => "input field",'
      end

      def run_migrations
        run_migrations = options[:auto_run_migrations] || ['', 'y', 'Y'].include?(ask 'Would you like to run the migrations now? [Y/n]')
        if run_migrations
          run 'bundle exec rake db:migrate'
          run 'bundle exec rake spree_cms:load:static_blocks'
        else
          puts 'Skipping rake db:migrate, don\'t forget to run it!'
        end
      end

    end
  end
end
