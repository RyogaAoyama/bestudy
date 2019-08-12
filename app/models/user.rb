class User < ApplicationRecord
  # 名前
  validates :name, presence: true, length: { maximum: 30 }
  validates :name, allow_blank: true, format: { with: /\A[^,'".\\\/=\?!:;]+\z/,
    message: 'に不正な文字が含まれています' }

  # ID
  validates :login_id, presence: true, uniqueness: true
  validates :login_id, allow_blank: true, 
    format: { with: /\A[^,'".\\\/=\?!:;]+\z/, message: 'に不正な文字が含まれています' }
  validates :login_id, allow_blank: true,
    format: { with: /\A[a-zA-Z_0-9]*\z/, message: 'は半角文字で入力してください' },
    length: { in: 6..30, message: 'は6文字以上30文字以内で入力してください' }

  REGEX = /\A[a-zA-Z_0-9]*\z/
  def id_type_check
    if id.match(REGEX)
      errors.add(:login_id, 'は半角文字で入力してください')
    end
  end
end
