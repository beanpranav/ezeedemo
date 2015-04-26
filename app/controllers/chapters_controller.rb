class ChaptersController < ApplicationController
  before_action :set_chapter, only: [:show, :edit, :update, :destroy]

  def index
    @chapters = Chapter.all
  end

  def show

    @study_materials = @chapter.study_materials.sort_by(&:material_no)
    @concept_materials = @study_materials.select { |x| x["material_type"] == "Quick Concepts" }
    @smart_materials = @study_materials.select { |x| x["material_type"] == "Learn Smart" }

    @rating_options = ["Clearly understood", "Somewhat understood", "Did not understand"]


    @all_assessments = []
    @concept_materials.each do |material| 
      if material.video_content != nil && material.video_content.assessment_contents != nil
        @all_assessments += material.video_content.assessment_contents.pluck(:id, :content_type, :mcq_answer)
      end
    end

    @mcqs = @all_assessments.select { |x| x[1] == "MCQ" }
    @shortqs = @all_assessments.select { |x| x[1] == "ShortQ" }
    @longqs = @all_assessments.select { |x| x[1] == "LongQ" }


    if user_signed_in?
      @user_concept_progresses = []
      @concept_materials.each do |study_material|
        if UserStudyProgress.where(user_id: current_user.id, study_material_id: study_material.id) != nil
          @user_concept_progresses += UserStudyProgress.where(user_id: current_user.id, study_material_id: study_material.id)
        end
      end

      @user_smart_progresses = []
      @smart_materials.each do |study_material|
        if UserStudyProgress.where(user_id: current_user.id, study_material_id: study_material.id) != nil
          @user_smart_progresses += UserStudyProgress.where(user_id: current_user.id, study_material_id: study_material.id)
        end
      end

      @user_mcq_progress_count = 0
      @user_mcq_correct_answer_count = 0
      @mcqs.each do |mcq|
        progress = UserAssessmentProgress.find_by(user_id: current_user.id, assessment_content_id: mcq[0])
        if progress != nil
          @user_mcq_progress_count += 1
          if progress.response == mcq[2]
            @user_mcq_correct_answer_count += 1
          end
        end
      end

      @user_shortq_progress_count = 0
      @shortqs.each do |shortq|
        progress = UserAssessmentProgress.where(user_id: current_user.id, assessment_content_id: shortq[0]).present?
        if progress
          @user_shortq_progress_count += 1
        end
      end

      @user_longq_progress_count = 0
      @longqs.each do |longq|
        progress = UserAssessmentProgress.where(user_id: current_user.id, assessment_content_id: longq[0]).present?
        if progress
          @user_longq_progress_count += 1
        end
      end

      concept_progress_ratio = @user_concept_progresses.count.to_f/@concept_materials.count
      smart_progress_ratio = @user_smart_progresses.count.to_f/@smart_materials.count
      mcq_progress_ratio = @user_mcq_correct_answer_count.to_f/@mcqs.count
      mcq_studied_ratio = @user_mcq_progress_count.to_f/@mcqs.count
      subjectiveq_progress_ratio = (@user_shortq_progress_count + @user_longq_progress_count).to_f/(@shortqs.count + @longqs.count)
      
      @cpi_level = current_user.cpi_calculator(smart_progress_ratio, concept_progress_ratio, mcq_progress_ratio, subjectiveq_progress_ratio)
      # @cpi_level = current_user.cpi_calculator(1,0.5,1,1)
      @chapter_studied = current_user.chapter_studied(smart_progress_ratio, concept_progress_ratio, mcq_studied_ratio, subjectiveq_progress_ratio)
      
      

      chapter_progress = UserChapterProgress.find_by(user_id: current_user.id, chapter_id: @chapter.id)
      if (chapter_progress == nil)
      # Save user's progress
        chapter_progress = UserChapterProgress.new user_id: current_user.id, chapter_id: @chapter.id, cpi_level: @cpi_level, chapter_studied: @chapter_studied
        chapter_progress.save
      else
      # Re-save progress data
        chapter_progress.cpi_level = @cpi_level 
        chapter_progress.chapter_studied = @chapter_studied
        chapter_progress.save
      end

    end

  end

# ASSESSMENT CONTROLLERS
  def study_mcqs

    @chapter = Chapter.friendly.find(params[:id])
    @concept_materials = @chapter.study_materials.where(:material_type == "Quick Concepts")

    @all_assessments = []
    @concept_materials.each do |material| 
      if material.video_content != nil && material.video_content.assessment_contents != nil
        @all_assessments += material.video_content.assessment_contents
      end
    end

    @mcqs = @all_assessments.select { |x| x["content_type"] == "MCQ" and x["practice_level"] == "Level 1"}

    if user_signed_in?
      
      @user_progresses = []
      @mcqs.each do |assessment_content|
        if UserAssessmentProgress.where(user_id: current_user.id, assessment_content_id: assessment_content.id) != nil
          @user_progresses += UserAssessmentProgress.where(user_id: current_user.id, assessment_content_id: assessment_content.id)
        end
      end

      @correct_answer_count = 0;
      @user_progresses.each do |progress|
        assessment_content = @mcqs.find { |x| x["id"] == progress.assessment_content_id }
        if assessment_content.mcq_answer == progress.response
          @correct_answer_count += 1 
        end 
      end

    end

  end

  def study_shortqs

    @chapter = Chapter.friendly.find(params[:id])
    @concept_materials = @chapter.study_materials.where(:material_type == "Quick Concepts")

    @all_assessments = []
    @concept_materials.each do |material| 
      if material.video_content != nil && material.video_content.assessment_contents != nil
        @all_assessments += material.video_content.assessment_contents
      end
    end

    @shortqs = @all_assessments.select { |x| x["content_type"] == "ShortQ" and x["practice_level"] == "Level 1" }

    @response_options = ["Revise again", "Completed"]

    if user_signed_in?
      @user_progresses = []
      @shortqs.each do |assessment_content|
        if UserAssessmentProgress.where(user_id: current_user.id, assessment_content_id: assessment_content.id) != nil
          @user_progresses += UserAssessmentProgress.where(user_id: current_user.id, assessment_content_id: assessment_content.id)
        end
      end
    end

  end

  def study_longqs

    @chapter = Chapter.friendly.find(params[:id])
    @concept_materials = @chapter.study_materials.where(:material_type == "Quick Concepts")

    @all_assessments = []
    @concept_materials.each do |material| 
      if material.video_content != nil && material.video_content.assessment_contents != nil
        @all_assessments += material.video_content.assessment_contents
      end
    end

    @longqs = @all_assessments.select { |x| x["content_type"] == "LongQ" and x["practice_level"] == "Level 1" }

    @response_options = ["Revise again", "Completed"]

    if user_signed_in?
      @user_progresses = []
      @longqs.each do |assessment_content|
        if UserAssessmentProgress.where(user_id: current_user.id, assessment_content_id: assessment_content.id) != nil
          @user_progresses += UserAssessmentProgress.where(user_id: current_user.id, assessment_content_id: assessment_content.id)
        end
      end
    end

  end





  def new
    @chapter = Chapter.new(subject_id: params[:subject_id], status: "Paid")
    @subject = Subject.find_by(id: params[:subject_id])
  end

  def edit
    @subject = @chapter.subject
  end

  def create
    @chapter = Chapter.new(chapter_params)

    respond_to do |format|
      if @chapter.save
        format.html { redirect_to chapter_path(@chapter), notice: 'Chapter was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    @subject = @chapter.subject

    respond_to do |format|
      if @chapter.update(chapter_params)
        format.html { redirect_to chapter_path(@chapter), notice: 'Chapter was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @chapter.destroy
    respond_to do |format|
      format.html { redirect_to chapters_url }
    end
  end




  # Actions for recording user's progress
  def save_user_study_progress
    if (UserStudyProgress.find_by(user_id: current_user.id, study_material_id: params[:study_material_id]) == nil)
    # Save user's progress
      p = UserStudyProgress.new user_id: current_user.id, study_material_id: params[:study_material_id], rating: params[:rating].index("")
      p.save
    else
    # Re-save rating
      p = UserStudyProgress.find_by(user_id: current_user.id, study_material_id: params[:study_material_id])
      p.rating = params[:rating].index("")
      p.save
    end
  
    flash[:notice] = "<b>Good Job!</b> Your progress has been saved."
    redirect_to chapter_path(params[:id])
  end

  def save_user_assessment_progress

    if user_signed_in?
      if (UserAssessmentProgress.find_by(user_id: current_user.id, assessment_content_id: params[:assessment_content_id]) == nil)
      # Save user's progress
        p = UserAssessmentProgress.new user_id: current_user.id, assessment_content_id: params[:assessment_content_id], response: params[:response].index("")
        p.save
      else
      # Re-save rating
        p = UserAssessmentProgress.find_by(user_id: current_user.id, assessment_content_id: params[:assessment_content_id])
        p.response = params[:response].index("")
        p.save
      end
    else
      flash[:notice] = '<b>Create an account</b> to explore the answers and save your progress. <br>Signup or login from <a href="/sign_up"><b>here</b></a>.' 
    end

    redirect_to params[:url]
  end




  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chapter
      @chapter = Chapter.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chapter_params
      params.require(:chapter).permit(:name, :chapterNumber, :term, :weightage_min, :weightage_max, :subject_id, :status, :slug)
    end
end
