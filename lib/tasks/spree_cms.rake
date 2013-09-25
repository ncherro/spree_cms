namespace :spree_cms do
  namespace :build do
    desc 'Generates Spree::StaticBlock instances from template files'
    task static_blocks: :environment do
      # find all static_block templates
      gem_path = "#{File.expand_path("../../../app/views/spree/cms/static_blocks", __FILE__)}/*"
      gem_templates = Dir.glob(gem_path).map { |t| t.split('/').last.split('.').first[1..-1] }

      rails_path = "#{File.join(Rails.root, 'app', 'views', 'spree', 'cms', 'static_blocks')}/*"
      rails_templates = Dir.glob(rails_path).map { |t| t.split('/').last.split('.').first[1..-1] }

      templates = gem_templates + rails_templates
      templates.uniq!

      templates.each do |t|
        sb = Spree::StaticBlock.find_or_initialize_by_template(t)
        if sb.new_record?
          sb.name = t.titleize
          if sb.save
            puts "Created '#{sb.name}'"
          else
            puts "Tried to create '#{sb.name}', but ran across these errors: #{sb.errors.full_messages.join(', ')}"
          end
        else
          puts "'#{sb.name}' already exists"
        end
      end

      # now delete any that do not exist
      Spree::StaticBlock.where('template NOT IN(?)', templates).each do |sb|
        puts "Deleting #{sb.name} - there is no template file for it"
        sb.destroy
      end

      puts "Done"
    end
  end
end
