require 'rails_helper'

RSpec.describe TestResult, type: :model do
  describe 'バリデーション' do
    let(:test_result) { TestResult.new }
    let(:err_msg) { test_result.errors.messages[:score] }

    describe '数値チェック' do
      context '0の場合' do
        it 'エラー' do
          test_result.score = 0
          test_result.valid?
          expect(err_msg).to include 'は1~100まで入力できます'
        end
      end
    end

      context '101の場合' do
        it 'エラー' do
          test_result.score = 101
          test_result.valid?
          expect(err_msg).to include 'は1~100まで入力できます'
        end
      end

      context '1の場合' do
        it '正常' do
          test_result.score = 1
          test_result.valid?
          expect(err_msg).to_not include 'は1~100まで入力できます'
        end
      end

      context '100の場合'do
        it '正常' do
          test_result.score = 100
          test_result.valid?
          expect(err_msg).to_not include 'は1~100まで入力できます'
        end
      end

      describe '文字チェック' do
        context '文字を入力した場合' do
          it 'エラー' do
            test_result.score = 'aa'
            test_result.valid?
            expect(err_msg).to include 'は数値のみ入力できます'
          end
        end
      end

      describe '空白チェック' do
        context '空白の場合' do
          it 'エラー' do
            test_result.score = '  '
            test_result.valid?
            expect(err_msg).to include 'を入力してください'
        end
      end
    end
  end
end
