class ProductsController < ApplicationController
  before_action :set_product, only: %i[ edit update destroy ]
  before_action :require_admin_user, only: [ :new, :edit, :update, :destroy ]
  # GET /products or /products.json
  def index
    @title = "All Products"
    if admin_user?
      @products = Product.all
    else
      @products = Product.where(available: true)
    end
  end

  # GET /products/1 or /products/1.json
  def show
    if admin_user?
      set_product
    else
      @product = Product.where(id: params[:id], available: true).first
      if !@product.present?
        redirect_to root_path
      end
    end
  end

  def show_by_category
    @title = "#{Category.where(id: params[:id]).pluck(:name).first} Products"
    if admin_user?
      @products = Product.get_by_category(params[:id])
    else
      @products = Product.get_by_category_and_available(params[:id])
    end
    render :index
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)
    respond_to do |format|
      if @product.save
        format.html { redirect_to product_url(@product), notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to product_url(@product), notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }
      else
        @categories = Category.all
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: "Product was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:name, :stock, :price, :description,
                                       :available, :model_number, :category_name,
                                       :brand_name, :engine_name,
                                      product_images_attributes: [ :id, :file, :_destroy ])
    end
end
