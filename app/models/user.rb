class User < ApplicationRecord
  has_one_attached :image
  belongs_to       :secret_question
  has_one          :room, dependent: :destroy
  has_one          :point, dependent: :destroy
  has_one          :room_request, dependent: :destroy
  has_many         :product
  has_many         :delivery, dependent: :destroy
  has_many         :order_history, dependent: :destroy
  has_many         :result, dependent: :destroy
  has_many         :product_request, dependent: :destroy
  has_many         :special_point, dependent: :destroy
  has_many         :goods, dependent: :destroy
  has_many         :notice, dependent: :destroy
  has_many         :point_notice, dependent: :destroy
  has_many         :test_result, dependent: :destroy
  # 名前
  validates :name, presence: true, length: { maximum: 30 }
  validates :name, allow_blank: true, format: { with: %r{\A[^,'".\\/=\?!:;]+\z},
                                                message: 'に不正な文字が含まれています' }

  # ログインID
  validates :login_id, presence: true, uniqueness: true
  validates :login_id, allow_blank: true,
                       format: { with: %r{\A[^,'".\\/=\?!:;]+\z}, message: 'に不正な文字が含まれています' }
  validates :login_id, allow_blank: true,
                       format: { with: /\A[a-zA-Z_0-9]*\z/, message: 'は半角文字で入力してください' },
                       length: { in: 6..30, message: 'は6文字以上30文字以内で入力してください' }

  # password
  has_secure_password validations: false
  with_options on: :create do |create|
    create.validates :password, presence: true, confirmation: true
    create.validates :password, allow_blank: true,
                                format: { with: %r{\A[^,'".\\/=\?!:;]+\z}, message: 'に不正な文字が含まれています' }
    create.validates :password, allow_blank: true,
                                format: { with: /\A[a-zA-Z_0-9]*\z/, message: 'は半角文字で入力してください' }
    create.validates :password, allow_blank: true,
                                format: { with: /\A(?=.*?[a-zA-Z])(?=.*?\d)[a-zA-Z\d_]+\z/, message: 'は英数字を含めてください' },
                                length: { in: 8..40, message: 'は8文字以上40文字以内で入力してください' }
  end

  with_options on: :password_only do |password_only|
    password_only.validates :password, presence: true, confirmation: true
    password_only.validates :password, allow_blank: true,
                                       format: { with: %r{\A[^,'".\\/=\?!:;]+\z}, message: 'に不正な文字が含まれています' }
    password_only.validates :password, allow_blank: true,
                                       format: { with: /\A[a-zA-Z_0-9]*\z/, message: 'は半角文字で入力してください' }
    password_only.validates :password, allow_blank: true,
                                       format: { with: /\A(?=.*?[a-z])(?=.*?\d)[a-z\d_]+\z/, message: 'は英数字を含めてください' },
                                       length: { in: 8..40, message: 'は8文字以上40文字以内で入力してください' }
  end

  # 秘密の質問
  validates :answer, presence: true
  validates :answer, allow_blank: true,
                     format: { with: %r{\A[^,'".\\/=\?!:;]+\z}, message: 'に不正な文字が含まれています' },
                     length: { maximum: 50 }

  validate :check_image
  def check_image
    return unless image.attached?

    whitelist = %w[image/jpeg image/png image/bmp]
    errors.add(:image, 'は画像ファイルのみ対応しています') if whitelist.exclude?(image.blob.content_type)
  end

  def default_image_set
    unless image.attached?
      File.open('public/default.jpg') do |f|
        image.attach(io: f, filename: 'default.jpg')
      end
    end
  end
end
