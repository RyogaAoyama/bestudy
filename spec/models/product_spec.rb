require "rails_helper"

describe "バリデーション" do
  before { @product = Product.new(id: 1) }
  let(:product)             { @product }
  let(:name_err_msg)        { product.errors.messages[:name] }
  let(:point_err_msg)       { product.errors.messages[:point] }
  let(:product_img_err_msg) { product.errors.messages[:product_img] }

  describe "商品名" do
    describe "文字数チェック" do
      shared_examples 'エラーメッセージが表示されない' do |str|
        it do
          product.name = str
          product.valid?
          expect(name_err_msg).to_not include "は30文字以内で入力してください"
        end
      end

      context "1文字の場合" do
        it_behaves_like 'エラーメッセージが表示されない', 'a'
      end

      context "30文字の場合" do
        it_behaves_like 'エラーメッセージが表示されない', 'a' * 30
      end

      context "31文字の場合" do
        it "エラーメッセージが表示される" do
          product.name = "a" * 31
          product.valid?
          expect(name_err_msg).to include "は30文字以内で入力してください"
        end
      end
    end

    describe "空白チェック" do
      it "エラーメッセージが表示されない" do
        product.name = "aa"
        product.valid?
        expect(name_err_msg).to_not include "を入力してください"
      end
      
      it "エラーメッセージが表示される" do
        product.name = "  "
        product.valid?
        expect(name_err_msg).to include "を入力してください"
      end
    end
  end

  describe "ポイント" do
    describe "入力値チェック" do
      shared_examples 'エラーメッセージが表示されない' do |num|
        it do
          product.point = num
          product.valid?
          expect(point_err_msg).to_not include "は1~99999ポイントまでです"
        end
      end

      shared_examples 'エラーメッセージが表示される' do |num|
        it do
          product.point = num
          product.valid?
          expect(point_err_msg).to include "は1~99999ポイントまでです"
        end
      end

      context "全角数字の場合" do
        it "半角数字に変換される" do
          product.point = product.half_size_change("２３４")
          expect(product.point).to eq 234
        end
      end

      context "数値の場合" do
          it_behaves_like 'エラーメッセージが表示されない', 234
      end

      context "1の場合" do
        it_behaves_like 'エラーメッセージが表示されない', 1
      end

      context "99999の場合" do
        it_behaves_like 'エラーメッセージが表示されない', 99999
      end

      context "0の場合" do
        it_behaves_like 'エラーメッセージが表示される', 0
      end

      context "100000の場合" do
        it_behaves_like 'エラーメッセージが表示される', 100000
      end

      context "文字の場合" do
        it "エラーメッセージが表示される" do
          product.point = "a"
          product.valid?
          expect(point_err_msg).to include "は数値を入力してください"
        end
      end
    end
  end

  describe "商品画像" do
    shared_examples 'エラーメッセージが表示されない' do |type|
      it do
        File.open("public/test.#{ type }") do |f|
          product.product_img.attach(io: f, filename: "test.#{ type }")
        end
        product.valid?
        expect(product_img_err_msg).to_not include 'は画像ファイルのみ対応しています'
      end
    end

    context "jpg" do
      it_behaves_like 'エラーメッセージが表示されない', 'jpg'
    end

    context "png" do
      it_behaves_like 'エラーメッセージが表示されない', 'png'
    end

    context "bmp" do
      it_behaves_like 'エラーメッセージが表示されない', 'bmp'
    end

    context 'txt' do
      it 'エラーメッセージが表示される' do
        File.open('public/test.txt') do |f|
          product.product_img.attach(io: f, filename: "test.txt")
        end
        product.valid?
        expect(product_img_err_msg).to include 'は画像ファイルのみ対応しています'
      end
    end
  end
end

describe '#exec_delete' do
  before { @product = create_product }
  it 'Product.is_deletedがtrueに更新される' do
    exec_delete
    expect(@product.is_deleted).to eq true
  end
end