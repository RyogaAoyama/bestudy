require 'rails_helper'

describe '科目' do
  let(:room) { Room.find(subject.room_id) }
  let(:subject) { FactoryBot.create(:subject) }
  let(:user) { User.find(room.user_id) }
  before do
    subject
    new_login(user.login_id, 'admin_user1')
    click_on '科目一覧'
  end
  
  describe '一覧' do
    it '一覧が表示されている' do
      # TODO: id決まったら決まったら修正
      expect(page).to have_selector 'ID'
    end

    context '科目データが存在しない場合' do
      it 'メッセージが表示されている' do
        expect(page).to have_content '科目は登録されていません'
      end
      it '科目登録ボタンが表示されている' do
        # ボタンのID決まったら修正
        expect(page).to have_selector 'btn-id'
      end
    end
  end
  
  describe '登録' do
    context '正常パターン' do
      before do
        click_on '科目登録'
        fill_in 'subject', with: '科目名'
        click_on '登録'
      end
      it '登録できる' do
        expect(Subject.all).to be_blank
      end
      it '登録完了メッセージが出力される' do
        expect(page).to have_content '「科目名」を登録しました'
      end
      it '一覧画面に遷移' do
        expect(current_user).to eq admin_subjects_path
      end
    end
    context 'エラーパターン' do
      it 'エラーが表示される' do
        click_on '科目登録'
        fill_in 'subject', with: '  '
        click_on '登録'
        exoect(page).to have_content '科目を入力してください'
      end
    end
  end

  describe '編集' do
    before { click_on '編集' }
    it '登録している科目名が入力されている' do
      expect(page).to have_field '科目名'
    end
    it '更新完了メッセージが表示されている' do
      fill_in 'subject', with: '算数'
      click_on '更新'
      expect(page).to have_content '科目を更新しました'
      expect(find("#subject-#{ subject.id }")).to have_content '算数'
    end
    it 'エラーが表示される' do
      fill_in 'subject', with: '  '
      click_on '更新'
      expect(page).to have_content '科目を入力してください'
    end
  end

  describe '削除' do
    before { click_on '削除' }
    it '削除確認モーダルが表示される' do
      expect(page).to have_selector '#modal'
    end
    it '削除完了メッセージが表示される' do
      click_on '科目を削除'
      expect(page).to '「科目名」を削除しました'
    end
    it '削除フラグが更新される' do
      click_on '科目を削除'
      expect(Subject.is_deleted).to be_truthy
    end
    it '戻るボタンを押下したらモーダルが消える' do
      click_on '戻る'
      expect(page).to_not have_selector '#modal'
    end
    it 'バツボタンを押下したらモーダルが消える' do
      find('#close').click
      expect(page).to_not have_selector '#modal'
    end
    it 'モーダル外を押下したらモーダルが消える' do
      find('#modal_outer').click
      expect(page).to_not have_selector '#modal'
    end
    #TODO: 成績入力作成したときに作る
    xit '成績入力画面から削除した科目が非表示になっている'
  end
end
