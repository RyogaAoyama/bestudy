class Product < ApplicationRecord
  has_one_attached :product_img
  belongs_to       :room
  belongs_to       :user
  has_one          :product_request, dependent: :destroy
  has_many         :delivery, dependent: :destroy
  has_many         :goods, dependent: :destroy

  scope :not_delete, ->(room) { room&.product&.where(is_deleted: false) }
  scope :not_request, -> { left_outer_joins(:product_request).where(product_requests: { product_id: nil }) }
  scope :join_good, lambda { |current_user|
    joins("LEFT OUTER JOIN goods ON goods.product_id = products.id AND goods.user_id = #{ current_user.id }")
      .select('products.*, goods.product_id, goods.user_id as g_user_id')
  }
  # 商品名
  validates :name, presence: true, length: { maximum: 30 }

  # ポイント
  validates :point, presence: true
  validates :point, numericality: { only_integer: true, message: 'は数値を入力してください' }
  validates :point, numericality: { greater_than: 0,
                                    less_than: 100_000,
                                    message: 'は1~99999ポイントまでです' }

  # 商品画像
  validate :check_image
  def check_image
    return unless product_img.attached?

    whitelist = %w[image/jpeg image/png image/bmp]
    errors.add(:product_img, 'は画像ファイルのみ対応しています') if whitelist.exclude?(product_img.blob.content_type)
  end

  def half_size_change(str_num)
    str_num.tr('０-９', '0-9') if str_num.is_a?(String)
  end

  def default_image_set
    unless product_img.attached?
      File.open('public/default.jpg') do |f|
        product_img.attach(io: f, filename: 'default.jpg')
      end
    end
  end

  # デフォルト値の設定
  def setup(user)
    self.user_id = user.id if user_id.blank?
    self.room_id = user.room_id if room_id.blank?
    self.point = 100 if point.blank?

    unless product_img.attached?
      File.open('public/default.jpg') do |f|
        product_img.attach(io: f, filename: 'default.jpg')
      end
    end
  end
end
