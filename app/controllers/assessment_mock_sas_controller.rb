class AssessmentMockSasController < ApplicationController
  before_action :set_assessment_mock_sa, only: [:show, :edit, :update, :destroy]

  def index
    @assessment_mock_sas = AssessmentMockSa.all
  end

  def show
    @subject = Subject.find_by(id: @assessment_mock_sa.subject_id)
  end

  def new
    @assessment_mock_sa = AssessmentMockSa.new(user_id: params[:user_id], subject_id: params[:subject_id], term: params[:term], attempt: params[:attempt], score: params[:score])
    @subject = Subject.find_by(id: params[:subject_id])
  end

  def edit
  end

  def create
    @assessment_mock_sa = AssessmentMockSa.new(assessment_mock_sa_params)

    respond_to do |format|
      if @assessment_mock_sa.save
        @subject = Subject.find_by(id: @assessment_mock_sa.subject_id)
        @term_chapters = @subject.chapters.where(term: @assessment_mock_sa.term).sort_by(&:chapterNumber)

        @all_assessments = []
        @term_chapters.each do |chapter|
          concept_materials = chapter.study_materials.where(material_type: "Quick Concepts").sort_by(&:material_no)
          concept_materials.each do |material| 
            if material.video_content != nil && material.video_content.assessment_contents != nil
              @all_assessments += material.video_content.assessment_contents.pluck(:id, :content_type, :marks, :practical_skills)
            end
          end
        end

        $mock_sa_specs["#{@subject.name.downcase}"][:paper_pattern].values.each do |section|
          questions = @all_assessments.select { |x| x[2] == section[:marks] and x[3] == section[:practical_skills] }
          sa_questions = questions.sample(section[:count])
          sa_questions.each do |q|
            sa_q = UserMockSaAssessmentContent.new assessment_mock_sa_id: @assessment_mock_sa.id, assessment_content_id: q[0], score: 0
            sa_q.save
          end
        end

        format.html { redirect_to @assessment_mock_sa, notice: "<b>All the Best!</b>" }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @assessment_mock_sa.update(assessment_mock_sa_params)
        format.html { redirect_to @assessment_mock_sa, notice: 'Assessment mock sa was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @assessment_mock_sa.destroy
    respond_to do |format|
      format.html { redirect_to assessment_mock_sas_url }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assessment_mock_sa
      @assessment_mock_sa = AssessmentMockSa.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def assessment_mock_sa_params
      params.require(:assessment_mock_sa).permit(:user_id, :subject_id, :term, :attempt, :score)
    end
end
