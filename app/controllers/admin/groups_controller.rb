class Admin::GroupsController < ApplicationController
  def new
    @group = Group.new
  end

  def show
  end

  def edit
  end

  def create
    @group = Group.new(get_group_params)
    user = User.new(session[:user])
    session[:user] = nil
    p user
    p @group
    if @group.save && user.save
      flash[:notice] = "登録が完了しました！ようこそ、#{ user.name }さん！"
      redirect_to admin_products_url
    else
      render :new
    end
  end

  private
  def get_group_params
    params.require(:group).permit(:name, :regist_id)
  end
end
