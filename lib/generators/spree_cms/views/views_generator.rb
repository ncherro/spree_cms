module SpreeCms
  module Generators
    class ViewsGenerator < Rails::Generators::Base
      def copy_templates
        directory(
          File.expand_path("../../../../../app/views/spree/cms", __FILE__),
          'app/views/spree/cms'
        )
      end
    end
  end
end
