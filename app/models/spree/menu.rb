class Spree::Menu < ActiveRecord::Base

 attr_accessible :title

 validates :title, uniqueness: true, presence: true

end
