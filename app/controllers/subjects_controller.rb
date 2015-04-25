class SubjectsController < ApplicationController
  before_action :set_subject, only: [:show, :edit, :update, :destroy]

  def index
    @subjects = Subject.all
  end

  def show
    @chapters_all = @subject.chapters.sort_by(&:chapterNumber)
    @chapters_term_1 = @chapters_all.select { |x| x["term"] == 1 }
    @chapters_term_2 = @chapters_all.select { |x| x["term"] == 2 }

    @chapter_ids_term_1 = []
    @chapters_term_1.each do |chapter|
      @chapter_ids_term_1 << chapter.id
    end
    @chapter_ids_term_2 = []
    @chapters_term_2.each do |chapter|
      @chapter_ids_term_2 << chapter.id
    end
    
    if user_signed_in?
      
      @term_1_chapters_studied = UserChapterProgress.where(user_id: current_user.id, chapter_id: @chapter_ids_term_1)
      @term_2_chapters_studied = UserChapterProgress.where(user_id: current_user.id, chapter_id: @chapter_ids_term_2)

      term_1_weightage_total = 0
      user_term_1_weightage = 0
      term_2_weightage_total = 0
      user_term_2_weightage = 0

      @chapters_term_1.each_with_index do |chapter, i|
        term_1_weightage_total += (chapter.weightage_min + chapter.weightage_max) / 2      
        user_progress = @term_1_chapters_studied.select { |x| x["chapter_id"] == chapter.id }
        if user_progress[0] != nil
          chapter_studied = user_progress[0].chapter_studied
          user_term_1_weightage += chapter_studied * (chapter.weightage_min + chapter.weightage_max) / 2 if chapter_studied != nil
        end 
      end

      @chapters_term_2.each_with_index do |chapter, i|
        term_2_weightage_total += (chapter.weightage_min + chapter.weightage_max) / 2      
        user_progress = @term_2_chapters_studied.select { |x| x["chapter_id"] == chapter.id }
        if user_progress[0] != nil
          chapter_studied = user_progress[0].chapter_studied
          user_term_2_weightage += chapter_studied * (chapter.weightage_min + chapter.weightage_max) / 2 if chapter_studied != nil
        end 
      end

      @term_1_studied = user_term_1_weightage/term_1_weightage_total
      @term_2_studied = user_term_2_weightage/term_2_weightage_total
      # @info = [@term_1_studied, user_term_1_weightage, term_1_weightage_total]

    else
      @term_1_studied = 0
      @term_2_studied = 0
    end

  end

  def new
    @subject = Subject.new
  end

  def edit
  end

  def subject_admin
    @subject = Subject.find_by(id:params[:id])
    @chapters_term_1 = @subject.chapters.select { |x| x["term"] == 1 }
    @chapters_term_2 = @subject.chapters.select { |x| x["term"] == 2 }
  end

  def create
    @subject = Subject.new(subject_params)

    respond_to do |format|
      if @subject.save
        format.html { redirect_to subjects_url, notice: 'Subject was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @subject.update(subject_params)
        format.html { redirect_to subjects_url, notice: 'Subject was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @subject.destroy
    respond_to do |format|
      format.html { redirect_to subjects_url }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subject
      @subject = Subject.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subject_params
      params.require(:subject).permit(:name, :board, :standard)
    end
end
