require 'rails_helper'

RSpec.describe PointNotice, type: :model do
  describe '#detail' do
    context 'タイプが１の場合' do
      let(:point_notice) { FactoryBot.build(:point_notice, type: 1) }
      it 'ポイントの付与理由が成績' do
        expect(point_notice.detail).to eq '成績が評価され、ポイントが付与されました'
      end
    end

    context 'タイプが２の場合' do
      let(:point_notice) { FactoryBot.build(:point_notice, type: 2) }
      it 'ポイントの付与理由が特別ポイント' do
        expect(point_notice.detail).to eq 'あなたの日々の頑張りが評価され、ポイントが付与されました。'
      end
    end

    context 'タイプが３の場合' do
      let(:point_notice) { FactoryBot.build(:point_notice, type: 3) }
      it 'ポイントの付与理由がテスト入力' do
        expect(point_notice.detail).to eq 'テスト結果が評価され、ポイントが付与されました'
      end
    end
  end
end
