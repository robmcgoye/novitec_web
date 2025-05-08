class Product < ApplicationRecord
  belongs_to :category
  belongs_to :engine
  belongs_to :brand
  has_many :product_images, dependent: :delete_all
  accepts_nested_attributes_for :product_images,
              allow_destroy: true,
              reject_if:  lambda { |a| a["file"].blank? }
  validates :name, :price, :model_number, :stock, presence: true
  validates :stock, numericality: true
  validates :price, numericality: { greater_than: 0, less_than: 10000000 }

  scope :get_by_category, ->(category_id) { where(category_id: category_id) }

  scope :get_by_category_and_available, ->(category_id) { get_by_category(category_id).where(available: true) }

  def category_name
    category.try(:name)
  end

  def category_name=(name)
    self.category = Category.find_or_create_by(name: name) if name.present?
  end

  def engine_name
    engine.try(:name)
  end

  def engine_name=(name)
    self.engine = Engine.find_or_create_by(name: name) if name.present?
  end

  def brand_name
    brand.try(:name)
  end

  def brand_name=(name)
    self.brand = Brand.find_or_create_by(name: name) if name.present?
  end
end
