require 'rails_helper'

describe '科目' do
  let(:room) { FactoryBot.create(:new_room) }
  let(:curriculum) { FactoryBot.create(:curriculum, room_id: room.id) }
  let(:user) { User.find(room.user_id) }
  before do
    new_login(user.login_id, 'admin_user1')
    click_on '科目一覧'
  end

  describe '一覧' do
    context '科目データが存在しない場合' do
      it 'メッセージが表示されている' do
        expect(page).to have_content '現在、登録されている科目はありません。'
      end
      it '科目登録ボタンが表示されている' do
        expect(page).to have_selector '#new_btn'
      end
    end
    
    context '科目データが存在する場合' do
      before do 
        curriculum
        click_on '科目一覧'
      end
      it '一覧が表示されている' do
        expect(page).to have_selector "#curriculum-#{ curriculum.id }"
      end
    end
  end
  
  describe '登録' do
    before do 
      click_on '科目登録'
    end

    context '正常パターン' do
      before do
        fill_in 'name', with: '科目名'
        click_on '登録'
      end
      it '登録できる' do
        expect(Curriculum.all).to be_present
      end
      it '登録完了メッセージが出力される' do
        expect(page).to have_content '「科目名」を登録しました'
      end
      it '一覧画面に遷移' do
        expect(current_path).to eq admin_curriculums_path
      end
    end
    context 'エラーパターン' do
      it 'エラーが表示される' do
        fill_in 'name', with: '  '
        click_on '登録'
        expect(page).to have_content '科目名を入力してください'
      end
    end
  end

  describe '編集' do
    before do
      curriculum
      visit admin_curriculums_path
      click_on "curriculum-#{ curriculum.id }"
    end
    it '登録している科目名が入力されている' do
      expect(page).to have_field with: '科目名'
    end
    it '更新完了メッセージが表示されている' do
      fill_in 'name', with: '算数'
      click_on '更新'
      expect(page).to have_content '科目を更新しました'
      expect(find("#curriculum-#{ curriculum.id }")).to have_content '算数'
    end
    it 'エラーが表示される' do
      fill_in 'name', with: '  '
      click_on '更新'
      expect(page).to have_content '科目名を入力してください'
    end
  end

  describe '削除' do
    before do
      curriculum
      visit admin_curriculums_path
      click_on '削除'
    end
      
    it '削除確認モーダルが表示される' do
      expect(page).to have_selector '#destroy-modal'
    end
    it '削除完了メッセージが表示される' do
      click_on '科目を削除'
      expect(page).to have_content '「科目名」を削除しました'
    end
    it '削除フラグが更新される' do
      click_on '科目を削除'
      # letのcurriculumだと値を使いまわすので更新した値が取得できない。
      # なのでfindで更新した値を取ってくる
      result = Curriculum.find(curriculum.id)
      expect(result.is_deleted).to be_truthy
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
