class Admin::RoomsController < ApplicationController
  def new
    @room = Room.new
  end

  def show
  end

  def edit
  end

  def create
    @room = Room.new(get_room_params)
    user = User.new(session[:user])
    session[:user] = nil
    # userのvalidateチェックは前画面でしているのでここでは必要ない
    if @room.save && user.save(validate: false)
      flash[:notice] = "登録が完了しました。ようこそ！#{ user.name }さん！"
      redirect_to admin_products_url
    else
      render :new
    end
  end

  private
  def get_room_params
    params.require(:room).permit(:name, :regist_id)
  end
end
