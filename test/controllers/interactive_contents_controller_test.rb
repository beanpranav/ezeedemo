require 'test_helper'

class InteractiveContentsControllerTest < ActionController::TestCase
  setup do
    @interactive_content = interactive_contents(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:interactive_contents)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create interactive_content" do
    assert_difference('InteractiveContent.count') do
      post :create, interactive_content: { admin_note: @interactive_content.admin_note, content_type: @interactive_content.content_type, name: @interactive_content.name, producer_name: @interactive_content.producer_name, production_date: @interactive_content.production_date }
    end

    assert_redirected_to interactive_content_path(assigns(:interactive_content))
  end

  test "should show interactive_content" do
    get :show, id: @interactive_content
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @interactive_content
    assert_response :success
  end

  test "should update interactive_content" do
    patch :update, id: @interactive_content, interactive_content: { admin_note: @interactive_content.admin_note, content_type: @interactive_content.content_type, name: @interactive_content.name, producer_name: @interactive_content.producer_name, production_date: @interactive_content.production_date }
    assert_redirected_to interactive_content_path(assigns(:interactive_content))
  end

  test "should destroy interactive_content" do
    assert_difference('InteractiveContent.count', -1) do
      delete :destroy, id: @interactive_content
    end

    assert_redirected_to interactive_contents_path
  end
end
