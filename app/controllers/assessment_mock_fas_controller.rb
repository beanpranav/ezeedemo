class AssessmentMockFasController < ApplicationController
  before_action :set_assessment_mock_fa, only: [:show, :edit, :update, :destroy]

  def index
    @assessment_mock_fas = AssessmentMockFa.all
  end

  def show
    @subject = Subject.find_by(id: @assessment_mock_fa.subject_id)
    @all_assessments = @assessment_mock_fa.assessment_contents
    @user_progresses = UserMockFaAssessmentContent.where(assessment_mock_fa_id: @assessment_mock_fa.id).sort_by(&:assessment_content_id)
  end

  def save_user_fa_progress
    p = UserMockFaAssessmentContent.find_by(assessment_mock_fa_id: params[:assessment_mock_fa_id], assessment_content_id: params[:assessment_content_id])
    p.response = params[:response].index("")
    p.save
    redirect_to params[:url]
  end

  def submit_test
    test = AssessmentMockFa.find(params[:assessment_mock_fa_id])
    test_questions = test.assessment_contents
    user_responses = test.user_mock_fa_assessment_contents
    user_score = 0
    
    test_questions.each do |question|
      progress = user_responses.select { |x| x.assessment_content_id == question.id }
      if progress[0].response == question.mcq_answer
        user_score += 1
      end
    end
   
    test.score = user_score
    test.save

    flash[:notice] = "<b>Good Job!</b> Your progress has been saved. <br>Your Score and the Answer Key is now available."
    redirect_to request.referrer
  end

  def new
    @assessment_mock_fa = AssessmentMockFa.new(user_id: params[:user_id], subject_id: params[:subject_id], term: params[:term], attempt: params[:attempt], score: params[:score])
    @subject = Subject.find_by(id: params[:subject_id])
    @term_chapters = @subject.chapters.where(term: params[:term]).sort_by(&:chapterNumber)
  end

  def edit
  end

  def create
    @assessment_mock_fa = AssessmentMockFa.new(assessment_mock_fa_params)

    if params[:chapter_ids] == nil
      flash[:notice] = "<b>Select atleast 1 chapter to be included in the test.</b>"
      redirect_to :back
    elsif params[:chapter_ids].count > 3
      flash[:notice] = "<b>Select atmost 3 chapters to be included in the test.</b>"
      redirect_to :back
    else
      @subject = Subject.find_by(id: @assessment_mock_fa.subject_id)
      @term_chapters = @subject.chapters.where(term: @assessment_mock_fa.term).sort_by(&:chapterNumber)
      
      @all_assessments = []
      params[:chapter_ids].each do |chapter_id|
        chapter = @term_chapters.select { |x| x.id == chapter_id.to_i }
        concept_materials = chapter[0].study_materials.where(material_type: "Quick Concepts").sort_by(&:material_no)
        concept_materials.each do |material| 
          if material.video_content != nil && material.video_content.assessment_contents != nil
            @all_assessments += material.video_content.assessment_contents.where(marks:1).pluck(:id)
          end
        end
      end
      fa_questions = @all_assessments.sample(15)

      respond_to do |format|
        if @assessment_mock_fa.save
          fa_questions.each do |q|
            fa_q = UserMockFaAssessmentContent.new assessment_mock_fa_id: @assessment_mock_fa.id, assessment_content_id: q, response: ""
            fa_q.save
          end
          format.html { redirect_to @assessment_mock_fa, notice: '<b>All the Best!</b>' }
        else
          format.html { render action: 'new' }
        end
      end

    end

  end

  def update
    respond_to do |format|
      if @assessment_mock_fa.update(assessment_mock_fa_params)
        format.html { redirect_to @assessment_mock_fa, notice: 'Assessment mock fa was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @assessment_mock_fa.destroy
    respond_to do |format|
      format.html { redirect_to assessment_mock_fas_url }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assessment_mock_fa
      @assessment_mock_fa = AssessmentMockFa.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def assessment_mock_fa_params
      params.require(:assessment_mock_fa).permit(:user_id, :subject_id, :term, :attempt, :score)
    end
end
