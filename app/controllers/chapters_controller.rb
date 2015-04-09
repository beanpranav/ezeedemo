class ChaptersController < ApplicationController
  before_action :set_chapter, only: [:show, :edit, :update, :destroy]

  def index
    @chapters = Chapter.all
  end

  def show
    @study_materials = @chapter.study_materials.sort_by(&:material_no)
    @concept_materials = @study_materials.select { |x| x["material_type"] == "Quick Concepts" }
    @smart_materials = @study_materials.select { |x| x["material_type"] == "Learn Smart" }

    @all_assessments = []
    @concept_materials.each do |material| 
      if material.video_content != nil && material.video_content.assessment_contents != nil
        @all_assessments += material.video_content.assessment_contents
      end
    end

    @mcqs = @all_assessments.select { |x| x["content_type"] == "MCQ" }
    @shortqs = @all_assessments.select { |x| x["content_type"] == "ShortQ" }
    @longqs = @all_assessments.select { |x| x["content_type"] == "LongQ" }

    @rating_options = ["Clearly understood", "Somewhat understood", "Did not understand"]

    if user_signed_in?
      @user_progresses = UserStudyProgress.where(user_id: current_user.id)
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
  
    flash[:notice] = 'Good Job! Your progress has been saved.'.html_safe
    redirect_to chapter_path(params[:id])

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chapter
      @chapter = Chapter.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chapter_params
      params.require(:chapter).permit(:name, :chapterNumber, :term, :subject_id, :status, :slug)
    end
end
