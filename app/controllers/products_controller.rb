class ProductsController < ApplicationController
  before_action :no_correct_access
  def index
    p "aaaa"
    p current_user.image
  end

  def buy
  end

  def history
  end
end
