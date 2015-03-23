class AssessmentContentsController < ApplicationController
  before_action :set_assessment_content, only: [:show, :edit, :update, :destroy]

  def index
    @assessment_contents = AssessmentContent.all
  end

  def show
  end

  def new
    @assessment_content = AssessmentContent.new(video_content_id: params[:video_content_id], content_type: params[:content_type], teacher_name: current_user.name)
    @video_content = VideoContent.find_by(id: params[:video_content_id])
  end

  def edit
    @video_content = @assessment_content.video_content
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
    @video_content = @assessment_content.video_content
    # raise params

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
      params.require(:assessment_content).permit(:video_content_id, :content_type, :question, :answer_a, :answer_b, :answer_c, :answer_d, :mcq_answer, :mcq_explanation, :teacher_name)
    end
end
