class SpecialPoint < ApplicationRecord
  belongs_to :room
  belongs_to :user

  include PointCalc
  include StringTrans

  validates :point, presence: true
  validates :point, numericality: { only_integer: true, message: 'は数値のみ入力できます' }
  validates :point, numericality: { greater_than: 0,
    less_than: 10000,
    message: 'は1~9999まで入力できます' }

    validates :message, length: { maximum: 300, message: 'は300文字まで入力できます' }
end
