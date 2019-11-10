class ProductsController < ApplicationController
  def index
    @products = Product.not_delete(join_room).not_request.join_good(current_user)
    @point = Point.find_by(user_id: current_user)
  end
end
