require 'rails_helper'

describe '成績' do
  let(:point) { FactoryBot.create(:point, user_id: nomal_user.id) }
  let(:nomal_user) { FactoryBot.create(:new_nomal_user, room_id: room.id) }
  let(:room) { FactoryBot.create(:new_room) }
  let(:curriculums) { 6.times.map { FactoryBot.create(:curriculum_sequence, room_id: room.id) } }

  before do
    room
    new_login('admin_user1', 'admin_user1')
  end

  describe 'ユーザー選択' do
    context 'ユーザーが存在しない場合' do
      it 'メッセージが表示される' do
        visit admin_results_path
        expect(page).to have_content '現在ルームに所属しているユーザーはいません'
      end
    end

    context 'ユーザーが存在する場合' do
      before do
        nomal_user
        point
        visit admin_results_path
      end

      it 'ユーザー一覧が表示される' do
        expect(page).to have_selector "#user-#{ nomal_user.id }"
      end
      it '一覧の項目が全て表示されている' do
        expect(page).to have_content nomal_user.name
        # TODO:これはユーザー写真登録ができてから
        # expect(find("#img-#{ nomal_user.id }")[:src]).to match 'public/test.jpg'
      end
    end
  end

  describe '登録前の確認' do
    it '確認モーダルが表示される' do
      curriculums
      nomal_user
      point
      visit admin_results_path
      click_on "user-#{ nomal_user.id }"
      choose "a-#{ curriculums[0].id }"
      click_on '登録'
      expect(page).to have_selector '#modal'
    end
  end

  describe '成績登録' do
    before do
      curriculums
      nomal_user
      point
      visit admin_results_path
      click_on "user-#{ nomal_user.id }"
    end

    context '科目が存在しない場合' do
      # 科目は登録しない
      let(:curriculums) { '' }
      it '表示項目が全て表示されている' do
        expect(page).to have_content '科目を登録してみよう!'
        expect(page).to have_selector '#curriculums-btn'
      end
      it '表示されない項目を確認' do
        expect { find('#point-wrap') }.to raise_error(Capybara::ElementNotFound)
        expect { find('#result-btn') }.to raise_error(Capybara::ElementNotFound)
      end
    end

    context '科目が存在する場合' do
      # 科目が存在しない場合のletが適用されるか確認
      before { curriculums }
      it '成績入力分のポイントが表示される' do
        choose "a-#{ curriculums[0].id }"
        expect(find('#point')).to have_content '100'
      end
      it '登録されている科目名が全て表示されている' do
        choose "a-#{ curriculums[0].id }"
        curriculums.each do |curriculum|
          expect(page).to have_content curriculum.name
        end
      end

      context '成績が入力されずに登録が押下された場合' do
        it 'エラーメッセージが表示' do
          click_on '登録'
          click_on '成績を登録'
          expect(page).to have_content '成績を入力してください'
        end
      end

      context '入力されていない箇所がある場合' do
        it '入力した箇所だけ登録する' do
          choose "b-#{ curriculums[0].id }"
          choose "c-#{ curriculums[1].id }"
          click_on '登録'
          click_on '成績を登録'
          expect(Result.all[0].result).to eq 2
          expect(Result.all[1].result).to eq 3
          expect(Result.all[2].result).to eq nil
        end
      end

      context '全ての成績が入力された場合' do
        before do
          choose "a-#{ curriculums[0].id }"
          choose "b-#{ curriculums[1].id }"
          choose "c-#{ curriculums[2].id }"
          choose "d-#{ curriculums[3].id }"
          choose "e-#{ curriculums[4].id }"
          choose "none-#{ curriculums[5].id }"
          click_on '登録'
          click_on '成績を登録'
        end
        it '全てのランクが登録されることを確認' do
          results = Result.all
          expect(results[0].result).to eq 1
          expect(results[1].result).to eq 2
          expect(results[2].result).to eq 3
          expect(results[3].result).to eq 4
          expect(results[4].result).to eq 5
          expect(results[5].result).to eq 0
        end
        it '登録完了のメッセージが表示される' do
          expect(page).to have_content '登録が完了しました'
          expect(current_path).to eq admin_results_path
        end
        it 'ユーザーにポイントが付与されている' do
          expect(nomal_user.point.point).to eq 300
        end
        # TODO:お知らせ機能ついたら
        it 'ユーザーにお知らせする'
      end
    end
  end
end
