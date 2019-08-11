class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }
  validates :name, allow_blank: true, format: { with: /\A[^,'".\\\/=\?!:;]+\z/,
    message: 'に不正な文字が含まれています' }
end
