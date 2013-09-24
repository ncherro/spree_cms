module SpreeCms
  module Generators
    class InstallGenerator < Rails::Generators::Base

      class_option :auto_run_migrations, :type => :boolean, :default => false

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

      def run_simple_form_generator
        run 'bundle exec rails g simple_form:install'
        gsub_file 'config/initializers/simple_form.rb', /:class => :hint/, ':class => :info'
        gsub_file 'config/initializers/simple_form.rb', /# config.default_input_size = 50/, 'config.default_input_size = 0'
      end

      def run_migrations
        run_migrations = options[:auto_run_migrations] || ['', 'y', 'Y'].include?(ask 'Would you like to run the migrations now? [Y/n]')
        if run_migrations
          run 'bundle exec rake db:migrate'
        else
          puts 'Skipping rake db:migrate, don\'t forget to run it!'
        end
      end
    end
  end
end
