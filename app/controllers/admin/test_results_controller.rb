class Admin::TestResultsController < ApplicationController
  def index
    @users = User.where(room_id: owner_room.id)
  end

  def new
    @curriculums = owner_room.curriculum.where(is_deleted: false)
    @test_result = TestResult.new
  end
end
