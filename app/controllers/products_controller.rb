class ProductsController < ApplicationController
  def index
    product_ids = join_room&.product&.where(is_deleted: false).pluck(:id)
    product_request = ProductRequest.where(product_id: product_ids).pluck(:product_id)
    @products = join_room&.product&.where(is_deleted: false).where.not(id: product_request)

    @point = Point.find_by(user_id: current_user)
  end
end
