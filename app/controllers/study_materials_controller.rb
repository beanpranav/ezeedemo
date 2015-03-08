class StudyMaterialsController < ApplicationController
  before_action :set_study_material, only: [:show, :edit, :update, :destroy]

  def index
    @study_materials = StudyMaterial.all
  end

  def show
  end

  def new
    @study_material = StudyMaterial.new
  end

  def edit
  end

  def create
    @study_material = StudyMaterial.new(study_material_params)

    respond_to do |format|
      if @study_material.save
        format.html { redirect_to study_materials_url, notice: 'Study material was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @study_material.update(study_material_params)
        format.html { redirect_to study_materials_url, notice: 'Study material was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @study_material.destroy
    respond_to do |format|
      format.html { redirect_to study_materials_url }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_study_material
      @study_material = StudyMaterial.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def study_material_params
      params.require(:study_material).permit(:name, :video_source, :video_duration, :model_source, :chapter_id)
    end
end
