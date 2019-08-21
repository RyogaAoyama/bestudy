class User < ApplicationRecord
  has_one_attached :image
  # 名前
  validates :name, presence: true, length: { maximum: 30 }
  validates :name, allow_blank: true, format: { with: /\A[^,'".\\\/=\?!:;]+\z/,
    message: 'に不正な文字が含まれています' }

  # ログインID
  validates :login_id, presence: true, uniqueness: true
  validates :login_id, allow_blank: true, 
    format: { with: /\A[^,'".\\\/=\?!:;]+\z/, message: 'に不正な文字が含まれています' }
  validates :login_id, allow_blank: true,
    format: { with: /\A[a-zA-Z_0-9]*\z/, message: 'は半角文字で入力してください' },
    length: { in: 6..30, message: 'は6文字以上30文字以内で入力してください' }

  # password
  has_secure_password validations: false
  with_options on: :create do |create|
    create.validates :password, presence: true, confirmation: true
    create.validates :password, allow_blank: true,
      format: { with: /\A[^,'".\\\/=\?!:;]+\z/, message: 'に不正な文字が含まれています' }
    create.validates :password, allow_blank: true,
      format: { with: /\A[a-zA-Z_0-9]*\z/, message: 'は半角文字で入力してください' }
    create.validates :password, allow_blank: true,
      format: { with: /\A(?=.*?[a-z])(?=.*?\d)[a-z\d_]+\z/, message: 'は英数字を含めてください'},
      length: { in: 8..40, message: 'は8文字以上40文字以内で入力してください' }
  end



  # 秘密の質問
  validates :answer, presence: true
  validates :answer, allow_blank: true, 
    format: { with: /\A[^,'".\\\/=\?!:;]+\z/, message: 'に不正な文字が含まれています' },
    length: { maximum: 50 }
end
