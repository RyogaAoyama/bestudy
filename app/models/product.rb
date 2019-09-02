class Product < ApplicationRecord
  has_one_attached :product_img
  belongs_to :user
  # 商品名
  validates :name, presence: true, length: { maximum: 30 }

  # ポイント
  validates :point, presence: true
  validates :point, numericality: { only_integer: true, message: 'は数値を入力してください' }
  validates :point, numericality: { greater_than: 0,
                                    less_than: 100000,
                                    message: 'は1~99999ポイントまでです' }

  # 商品画像
  validate :check_image
  def check_image
    return unless product_img.attached?
    whitelist = %w[image/jpeg image/png image/bmp]
    if whitelist.exclude?(product_img.blob.content_type)
      errors.add(:product_img, 'は画像ファイルのみ対応しています')
    end
  end

  def half_size_change(str_num)
    if str_num.is_a?(String)
      str_num.tr('０-９', '0-9')
    end
  end

  def default_image_set
    File.open('public/default.jpg') do |f|
      self.product_img.attach(io: f, filename: "default.jpg")
    end
  end
end
