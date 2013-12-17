class Spree::CmsFile < ActiveRecord::Base

  # dragonfly
  file_accessor :file

  belongs_to :fileable, polymorphic: true

  attr_accessible :retained_file, :file_url, :remove_file, :title, :name, :file

  validates :name, :file, presence: true
  validates :name, uniqueness: true
  validates_size_of :file, maximum: 10.megabytes
  validates_property :format, of: :file, in: [:pdf, :zip, :doc,]

end
