require 'test_helper'

class VideoContentsControllerTest < ActionController::TestCase
  setup do
    @video_content = video_contents(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:video_contents)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create video_content" do
    assert_difference('VideoContent.count') do
      post :create, video_content: { admin_note: @video_content.admin_note, content_type: @video_content.content_type, name: @video_content.name, producer_name: @video_content.producer_name, production_date: @video_content.production_date, video_duration: @video_content.video_duration }
    end

    assert_redirected_to video_content_path(assigns(:video_content))
  end

  test "should show video_content" do
    get :show, id: @video_content
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @video_content
    assert_response :success
  end

  test "should update video_content" do
    patch :update, id: @video_content, video_content: { admin_note: @video_content.admin_note, content_type: @video_content.content_type, name: @video_content.name, producer_name: @video_content.producer_name, production_date: @video_content.production_date, video_duration: @video_content.video_duration }
    assert_redirected_to video_content_path(assigns(:video_content))
  end

  test "should destroy video_content" do
    assert_difference('VideoContent.count', -1) do
      delete :destroy, id: @video_content
    end

    assert_redirected_to video_contents_path
  end
end
