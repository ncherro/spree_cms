require 'active_support/concern'

module Spree::CmsConcerns::PartialPathFix

  extend ActiveSupport::Concern

  # instance methods
  included do
    def to_partial_path
      # this allows us to render CMS model instances without manually
      # specifying the template path
      super.gsub(/^spree\//, 'spree/cms/')
    end
  end

end
