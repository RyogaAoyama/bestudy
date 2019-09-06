class Admin::ProductRequestsController < ApplicationController
  def index
    #TODO:グループ取得のメソッド作成する
    @product_requests = current_user.product.where(is_deleted: false)
  end

  def new
  end
end
