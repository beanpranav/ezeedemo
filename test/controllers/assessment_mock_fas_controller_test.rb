require 'test_helper'

class AssessmentMockFasControllerTest < ActionController::TestCase
  setup do
    @assessment_mock_fa = assessment_mock_fas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:assessment_mock_fas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create assessment_mock_fa" do
    assert_difference('AssessmentMockFa.count') do
      post :create, assessment_mock_fa: { attempt: @assessment_mock_fa.attempt, score: @assessment_mock_fa.score, subject_id: @assessment_mock_fa.subject_id, term: @assessment_mock_fa.term, user_id: @assessment_mock_fa.user_id }
    end

    assert_redirected_to assessment_mock_fa_path(assigns(:assessment_mock_fa))
  end

  test "should show assessment_mock_fa" do
    get :show, id: @assessment_mock_fa
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @assessment_mock_fa
    assert_response :success
  end

  test "should update assessment_mock_fa" do
    patch :update, id: @assessment_mock_fa, assessment_mock_fa: { attempt: @assessment_mock_fa.attempt, score: @assessment_mock_fa.score, subject_id: @assessment_mock_fa.subject_id, term: @assessment_mock_fa.term, user_id: @assessment_mock_fa.user_id }
    assert_redirected_to assessment_mock_fa_path(assigns(:assessment_mock_fa))
  end

  test "should destroy assessment_mock_fa" do
    assert_difference('AssessmentMockFa.count', -1) do
      delete :destroy, id: @assessment_mock_fa
    end

    assert_redirected_to assessment_mock_fas_path
  end
end
