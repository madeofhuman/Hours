class CategoriesController < ApplicationController
  before_action :find_category, only: [:show, :edit, :update]

  def index
    @category = Category.new
    @categories = Category.by_name
  end

  def show
    @projects = Project.joins(:categories)
                       .where('categories.id = ?', @category.id)
                       .uniq
                       .unarchived
                       .by_last_updated
                       .page(params[:page])
                       .per(7)
  end

  def create
    @category = Category.new(category_params)
    if @category.sav
      redirect_to categories_path, notice: t(:category_created)
    else
      @categories = Category.by_name
      render "categories/index"
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to categories_path, notice: t(:category_updated)
    else
      render :edit
    end
  end

  private

  def find_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
