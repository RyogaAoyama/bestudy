class TestResult < ApplicationRecord
  belongs_to :user
  belongs_to :room
  belongs_to :curriculum

  validates :score, presence: true
  validates :score, numericality: { only_integer: true, message: 'は数値のみ入力できます' }
  validates :score, numericality: { greater_than: 0,
    less_than: 101,
    message: 'は1~100まで入力できます' }

  include StringTrans
end
