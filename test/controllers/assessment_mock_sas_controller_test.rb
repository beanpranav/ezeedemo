require 'test_helper'

class AssessmentMockSasControllerTest < ActionController::TestCase
  setup do
    @assessment_mock_sa = assessment_mock_sas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:assessment_mock_sas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create assessment_mock_sa" do
    assert_difference('AssessmentMockSa.count') do
      post :create, assessment_mock_sa: { attempt: @assessment_mock_sa.attempt, score: @assessment_mock_sa.score, subject_id: @assessment_mock_sa.subject_id, term: @assessment_mock_sa.term, user_id: @assessment_mock_sa.user_id }
    end

    assert_redirected_to assessment_mock_sa_path(assigns(:assessment_mock_sa))
  end

  test "should show assessment_mock_sa" do
    get :show, id: @assessment_mock_sa
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @assessment_mock_sa
    assert_response :success
  end

  test "should update assessment_mock_sa" do
    patch :update, id: @assessment_mock_sa, assessment_mock_sa: { attempt: @assessment_mock_sa.attempt, score: @assessment_mock_sa.score, subject_id: @assessment_mock_sa.subject_id, term: @assessment_mock_sa.term, user_id: @assessment_mock_sa.user_id }
    assert_redirected_to assessment_mock_sa_path(assigns(:assessment_mock_sa))
  end

  test "should destroy assessment_mock_sa" do
    assert_difference('AssessmentMockSa.count', -1) do
      delete :destroy, id: @assessment_mock_sa
    end

    assert_redirected_to assessment_mock_sas_path
  end
end
