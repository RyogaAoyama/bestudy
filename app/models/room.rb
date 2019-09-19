class Room < ApplicationRecord
  belongs_to  :user, optional: true
  has_many    :product, dependent: :destroy
  has_many    :delivery, dependent: :destroy
  has_many    :curriculum, dependent: :destroy
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
end
