module ProductsHelper
  def get_product_image_url(product_image)
    product_image.file_url
  end
end
