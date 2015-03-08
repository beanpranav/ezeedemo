require 'test_helper'

class StudyMaterialsControllerTest < ActionController::TestCase
  setup do
    @study_material = study_materials(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:study_materials)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create study_material" do
    assert_difference('StudyMaterial.count') do
      post :create, study_material: { chapter_id: @study_material.chapter_id, model_source: @study_material.model_source, name: @study_material.name, video_duration: @study_material.video_duration, video_source: @study_material.video_source }
    end

    assert_redirected_to study_material_path(assigns(:study_material))
  end

  test "should show study_material" do
    get :show, id: @study_material
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @study_material
    assert_response :success
  end

  test "should update study_material" do
    patch :update, id: @study_material, study_material: { chapter_id: @study_material.chapter_id, model_source: @study_material.model_source, name: @study_material.name, video_duration: @study_material.video_duration, video_source: @study_material.video_source }
    assert_redirected_to study_material_path(assigns(:study_material))
  end

  test "should destroy study_material" do
    assert_difference('StudyMaterial.count', -1) do
      delete :destroy, id: @study_material
    end

    assert_redirected_to study_materials_path
  end
end
