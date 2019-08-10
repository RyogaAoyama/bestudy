class AcountsController < ApplicationController
  def nomal_new
    @user = User.new
  end

  def index
  end

  def admin_new
  end

  def show
  end

  def edit
  end

  def create
    @user = User.new( get_regist_user )
    @user.valid?
    p @user.name
    render :nomal_new
  end

  private
  def get_regist_user
    params.require( :user ).permit( :name )
  end
end
