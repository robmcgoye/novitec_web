class Category < ApplicationRecord
  validates :name, presence: true
  has_many :products

  scope :categories_with_products, -> { joins(:products).distinct }
  scope :categories_with_products_and_available, -> { joins(:products).where("products.available = true").distinct }
end
