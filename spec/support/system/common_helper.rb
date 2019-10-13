# 全機能共通ヘルパー
module CommonHelper
  def login
    FactoryBot.create(:secret_question)
    user = FactoryBot.create(:user)
    FactoryBot.create(:room)
    visit login_path
    fill_in 'login_id', with: user.login_id
    fill_in 'password', with: user.password
    click_on 'ログイン'
    p "ログイン成功"
  end

  def clear
    ProductRequest.all.delete_all
    Product.all.delete_all
    Room.all.delete_all
    User.all.delete_all
    SecretQuestion.all.delete_all
  end

  def create_nomal_user
    FactoryBot.create(:secret_question2)
    FactoryBot.create(:nomal_user)
  end

  def create_product_request
    FactoryBot.create(:secret_question2)
    user = FactoryBot.create(:nomal_user)
    product = FactoryBot.create(:product, user_id: user.id)
    FactoryBot.create(:product_request, user_id: user.id, product_id: product.id)
  end
###########上のヘルパーメソッドは色々混ざりすぎて使いづらいので使わないこと##################
###########既存のテストコードがあるので削除できない、完全にミスった...######################

  def new_login(login_id, password)
    visit login_path
    fill_in 'login_id', with: login_id
    fill_in 'password', with: password
    click_on 'ログイン'
    p "ログイン成功"
  end

  def get_owner_user(room)
    owner_user = User.find(room.user_id)
  end

  def create_delivery
    user = FactoryBot.create(:new_nomal_user)
    room = FactoryBot.create(:new_room)
    room_owner = get_owner_user(room)

    product = FactoryBot.create(
      :new_product,
      room_id: room.id,
      user_id: room_owner.id
    )
    order_history = FactoryBot.create(
      :order_history,
      room_id: room.id,
      user_id: user.id,
      product_id: product.id
    )
    FactoryBot.create(
      :delivery,
      user_id: user.id,
      room_id: room.id,
      product_id: product.id,
      order_history_id: order_history.id
    )
  end
end