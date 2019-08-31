require "rails_helper"

describe "バリデーション" do
  before { @product = Product.new(id: 1) }
  let(:product) { @product }
  describe "商品名" do
    describe "文字数チェック" do
      context "1文字の場合" do
        it "エラーメッセージが表示されない" do
          product.name = "a"
          expect(product.errors.messages[:name]).to_not include "は30文字以内で入力してください"
        end
      end

      context "30文字の場合" do
        it "エラーメッセージが表示されない" do
          product.name = "a" * 30
          expect(product.errors.messages[:name]).to_not include "は30文字以内で入力してください"
        end
      end

      context "31文字の場合" do
        it "エラーメッセージが表示される" do
          product.name = "a" * 31
          expect(product.errors.messages[:name]).to include "は30文字以内で入力してください"
        end
      end

      describe "空白チェック" do
        it "エラーメッセージが表示されない" do
          product.name = "aa"
          expect(product.errors.messages[:name]).to include "を入力してください"
        end
        it "エラーメッセージが表示される" do
          product.name = "  "
          expect(product.errors.messages[:name]).to include "を入力してください"
        end
      end
    end
  end

  describe "ポイント" do
    describe "数値チェック" do
      context "全角数字の場合" do
        it "半角に変換して登録される" do
          product.point = "２３４"
          expect(product.half_size_change).to eq 234
        end
      end

      context "数値の場合" do
        it "エラーメッセージが表示されない" do
          product.point = 234
          product.valid?
          expect(product.errors.messages[:point]).to_not "を入力してください"
        end
      end

      context "文字の場合" do
        it "エラーメッセージが表示される" do
          product.point = "a"
          expect(product.errors.messages[:point]).to include "を入力してください"
        end
      end

      describe "上限チェック" do
        context "1の場合" do
          it "エラーメッセージが表示されない" do
            product.point = 1
            product.valid?
            expect(product.errors.messages[:point]).to_not include "は1~99999ポイントまでです"
          end
        end

        context "99999" do
          it "エラーメッセージが表示されない" do
            product.point = 99999
            product.valid?
            expect(product.errors.messages[:point]).to_not include "は1~99999ポイントまでです"
          end
        end

        context "0の場合" do
          it "エラーメッセージが表示される" do
            product.point = 0
            product.valid?
            expect(product.errors.messages[:point]).to include "は1~99999ポイントまでです"
          end
        end

        context "100000の場合" do
          it "エラーメッセージが表示される" do
            product.point = 100000
            product.valid?
            expect(product.errors.messages[:point]).to include "は1~99999ポイントまでです"
          end
        end
      end
    end
  end

  describe "商品画像" do
    context "jpg" do
      it "アップロードできる" do
        product.image.filename = 'text.jpg'
        product.check_image
        expect(product.errors.messages[:image]).to_not include 'このファイルは対応していません'
      end
    end

    context "png" do
      it "アップロードできる" do
        product.image.filename = 'text.png'
        product.check_image
        expect(product.errors.messages[:image]).to_not include 'このファイルは対応していません'
      end
    end

    context "gif" do
      it "アップロードできる" do
        product.image.filename = 'text.gif'
        product.check_image
        expect(product.errors.messages[:image]).to_not include 'このファイルは対応していません'
      end
    end

    context "bmp" do
      it "アップロードできる" do
        product.image.filename = 'text.bmp'
        product.check_image
        expect(product.errors.messages[:image]).to_not include 'このファイルは対応していません'
      end
    end

    context 'txt' do
      it 'エラーメッセージが表示される' do
        product.image.filename = 'text.txt'
        product.check_image
        expect(product.errors.messages[:image]).to include 'このファイルは対応していません'
      end
    end
  end
end
