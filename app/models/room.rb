# ルームモデル
class Room < ApplicationRecord
  belongs_to  :user, optional: true
  has_many    :product, dependent: :destroy
  has_many    :delivery, dependent: :destroy
  has_many    :curriculum, dependent: :destroy
  has_many    :result, dependent: :destroy
  has_many    :room_request
  # グループ名
  validates :name, presence: true, length: { maximum: 30 }
  validates :name, allow_blank: true,
    format: { with: /\A[^,'".\\\/=\?!:;]+\z/, message: 'に不正な文字が含まれています' }
  
  # グループID
  validates :regist_id, presence: true, uniqueness: true
  validates :regist_id, allow_blank: true,
    format: { with: /\A[^,'".\\\/=\?!:;]+\z/, message: 'に不正な文字が含まれています' }
    validates :regist_id, allow_blank: true,
      format: { with: /\A[a-zA-Z_0-9]*\z/, message: 'は半角文字で入力してください' },
      length: { in: 6..10, message: 'は6文字以上10文字以内で入力してください' }
  
  # ユーザーとルームの中間テーブルを作るべきだった....
  # ルーム退会時の処理がめんどくさい....
  def self.user_exit?(user)
    user.transaction do
      user.delivery.destroy_all
      user.good.destroy_all
      user.notice.destroy_all
      user.order_history.destroy_all
      user.point_notice.destroy_all
      user.product_request.destroy_all
      user.result.destroy_all
      user.special_point.destroy_all
      user.test_result.destroy_all

      user.room_id = ''
      user.save!

      point = user.point
      point.total = 0
      point.point = 0
      point.assign_attributes(total: 0, point: 0)
      point.save!
      return true
    rescue
      p $!
      return false
    end
  end
end
