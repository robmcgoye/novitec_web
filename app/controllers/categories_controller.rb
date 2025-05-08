class CategoriesController < ApplicationController
  before_action :set_category, only: [ :edit, :update, :destroy ]
  before_action :require_admin_user

  # GET /categories
  def index
    @categories = Category.all
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories
  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to categories_path, notice: "Category was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /categories/1
  def update
    if @category.update(category_params)
      redirect_to categories_path, notice: "Category was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /categories/1
  def destroy
    if !@category.products.present?
      @category.destroy
      redirect_to categories_url, notice: "Category was successfully deleted."
    else
      flash[:alert] = "Can't delete category since it is still referenced in #{@category.products.count} #{"product".pluralize(@category.products.count)}"
      redirect_to edit_category_path(@category)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def category_params
      params.require(:category).permit(:name)
    end
end
