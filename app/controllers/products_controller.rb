class ProductsController < ApplicationController
  def index
    @products = belongs_to_room&.product&.where(is_deleted: false)
  end
end
