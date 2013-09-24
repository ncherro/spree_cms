class Spree::StaticBlock < Spree::Block

  validates :template, presence: true, uniqueness: true

end
