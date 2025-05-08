class ProductImage < ApplicationRecord
  belongs_to :product
  mount_uploader :file, ImagesUploader
end
