class Spree::Block < ActiveRecord::Base

  attr_accessible :content, :name, :template

  validates :name, presence: true

  validates :template, format: { with: /\A\w+\z/ }, allow_blank: true

  def label_for_select
    "#{self.class.name.demodulize.titleize} - #{self.name}"
  end

end
