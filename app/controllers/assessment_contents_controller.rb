class AssessmentContentsController < ApplicationController
  before_action :set_assessment_content, only: [:show, :edit, :update, :destroy]

  def index
    @assessment_contents = AssessmentContent.all
  end

  def show
  end

  def new
    @assessment_content = AssessmentContent.new
  end

  def edit
  end

  def create
    @assessment_content = AssessmentContent.new(assessment_content_params)

    respond_to do |format|
      if @assessment_content.save
        format.html { redirect_to @assessment_content, notice: 'Assessment content was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @assessment_content.update(assessment_content_params)
        format.html { redirect_to @assessment_content, notice: 'Assessment content was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @assessment_content.destroy
    respond_to do |format|
      format.html { redirect_to assessment_contents_url }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assessment_content
      @assessment_content = AssessmentContent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def assessment_content_params
      params.require(:assessment_content).permit(:video_content_id, :question, :choice_a, :choice_b, :choice_c, :choice_d, :answer, :difficulty_level, :next_step)
    end
end
