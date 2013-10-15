require 'active_support/concern'

module Spree::CmsConcerns::PartialPathFix

  extend ActiveSupport::Concern

  # instance methods
  included do
    def to_partial_path
      # this allows us to render CMS model instances without manually
      # specifying the template path
      path = super.gsub(/^spree\//, 'spree/cms/')
      if self.respond_to?('template') && self.template.present?
        # replace model name with the template override
        return (path.split('/')[0..-2] + [self.template]).join('/')
      end
      path
    end
  end

end
