class Common::NoticesController < ApplicationController
  def index
    # テーブルのカラムの用途が一般と管理人で違ったため無茶苦茶な条件になった
    # 必ず次に活かすこと
    @notices = if current_user.is_admin
                 Notice.where(type: [3, 4, 5]).where(room_id: owner_room.id)
               else
                 Notice.where(type: [1, 2]).where(user_id: current_user.id)
               end
  end
end
