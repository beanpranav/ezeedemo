require 'test_helper'

class AssessmentContentsControllerTest < ActionController::TestCase
  setup do
    @assessment_content = assessment_contents(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:assessment_contents)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create assessment_content" do
    assert_difference('AssessmentContent.count') do
      post :create, assessment_content: { answer: @assessment_content.answer, choice_a: @assessment_content.choice_a, choice_b: @assessment_content.choice_b, choice_c: @assessment_content.choice_c, choice_d: @assessment_content.choice_d, difficulty_level: @assessment_content.difficulty_level, next_step: @assessment_content.next_step, question: @assessment_content.question, video_content_id: @assessment_content.video_content_id }
    end

    assert_redirected_to assessment_content_path(assigns(:assessment_content))
  end

  test "should show assessment_content" do
    get :show, id: @assessment_content
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @assessment_content
    assert_response :success
  end

  test "should update assessment_content" do
    patch :update, id: @assessment_content, assessment_content: { answer: @assessment_content.answer, choice_a: @assessment_content.choice_a, choice_b: @assessment_content.choice_b, choice_c: @assessment_content.choice_c, choice_d: @assessment_content.choice_d, difficulty_level: @assessment_content.difficulty_level, next_step: @assessment_content.next_step, question: @assessment_content.question, video_content_id: @assessment_content.video_content_id }
    assert_redirected_to assessment_content_path(assigns(:assessment_content))
  end

  test "should destroy assessment_content" do
    assert_difference('AssessmentContent.count', -1) do
      delete :destroy, id: @assessment_content
    end

    assert_redirected_to assessment_contents_path
  end
end
