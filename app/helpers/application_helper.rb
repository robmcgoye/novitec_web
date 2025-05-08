module ApplicationHelper
  def get_nav_categories
    if admin_user?
      Category.categories_with_products
    else
      Category.categories_with_products_and_available
    end
  end
end
