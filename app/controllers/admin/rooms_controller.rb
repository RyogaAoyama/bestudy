class Admin::RoomsController < ApplicationController
  def new
    @room = Room.new
  end

  def show
  end

  def edit_name
    @room = current_user.room
    p @room
  end

  def update_name
    # TODO:POSTで送られてきた値をそのままupdateで使えるか実験
    @room = current_user.room
    if @room.update(room_params)
      flash[:notice] = '編集内容を保存しました'
      redirect_to admin_room_url(params[:id])
    else
      render :edit_name
    end
  end

  def create
    user = User.new(session[:user])
    @room = Room.new(room_params)
    session[:user] = nil
    if @room.valid?
      # userのvalidateチェックは前画面でしているのでここでは必要ない
      user.save(validate: false)
      @room.user_id = user.id
      @room.save
      flash[:notice] = "登録が完了しました。ようこそ！#{ user.name }さん！"
      session[:id] = user.id
      redirect_to admin_products_url
    else
      render :new
    end
  end

  private
  def room_params
    params.require(:room).permit(:name, :regist_id)
  end
end
