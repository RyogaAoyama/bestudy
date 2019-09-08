class Admin::ProductRequestsController < ApplicationController
  def index
    users = User.where(room_id: owner_room)
    product_requests = ProductRequest.where(user_id: users.id)
    @products = Product.where(id: product_requests.product_id)
  end

  def new
  end
end
