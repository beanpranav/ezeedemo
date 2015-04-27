class SubjectsController < ApplicationController
  before_action :set_subject, only: [:show, :edit, :update, :destroy]

  def index
    @subjects = Subject.all
  end

  def show
    @chapters_all = @subject.chapters.sort_by(&:chapterNumber)
    @term_1_chapters = @chapters_all.select { |x| x["term"] == 1 }
    @term_2_chapters = @chapters_all.select { |x| x["term"] == 2 }

    chapter_ids_term_1 = []
    @term_1_chapters.each do |chapter|
      chapter_ids_term_1 << chapter.id
    end
    chapter_ids_term_2 = []
    @term_2_chapters.each do |chapter|
      chapter_ids_term_2 << chapter.id
    end
    
    if user_signed_in?
      
      @term_1_weight = 0
      @term_1_chapters.each do |chapter|
        @term_1_weight += (chapter.weightage_min + chapter.weightage_max) / 2
      end

      @term_2_weight = 0
      @term_2_chapters.each do |chapter|
        @term_2_weight += (chapter.weightage_min + chapter.weightage_max) / 2
      end

      @user_term_1_chapters_studied = UserChapterProgress.where(user_id: current_user.id, chapter_id: chapter_ids_term_1)
      @user_term_2_chapters_studied = UserChapterProgress.where(user_id: current_user.id, chapter_id: chapter_ids_term_2)

      @term_1_studied = current_user.subject_studied(@term_1_chapters, @user_term_1_chapters_studied)
      @term_2_studied = current_user.subject_studied(@term_2_chapters, @user_term_2_chapters_studied)
      
      @term_1_spi = current_user.predictive_score_calculator(@term_1_chapters, @user_term_1_chapters_studied, [], [])
      @term_2_spi = current_user.predictive_score_calculator(@term_2_chapters, @user_term_2_chapters_studied, [], [])

    else
      @term_1_studied = 0
      @term_2_studied = 0
      @term_1_spi = 0
      @term_2_spi = 0
    end

  end

  def new
    @subject = Subject.new
  end

  def edit
  end

  def subject_admin
    @subject = Subject.friendly.find(params[:id])
    @chapters_term_1 = @subject.chapters.select { |x| x["term"] == 1 }
    @chapters_term_2 = @subject.chapters.select { |x| x["term"] == 2 }
  end

  def improve_predictive_score
    @subject = Subject.friendly.find(params[:id])
    @chapters_all = @subject.chapters.sort_by(&:chapterNumber)
    @term_1_chapters = @chapters_all.select { |x| x["term"] == 1 }
    @term_2_chapters = @chapters_all.select { |x| x["term"] == 2 }

    chapter_ids_term_1 = []
    @term_1_chapters.each do |chapter|
      chapter_ids_term_1 << chapter.id
    end
    chapter_ids_term_2 = []
    @term_2_chapters.each do |chapter|
      chapter_ids_term_2 << chapter.id
    end
    
    if user_signed_in?
      
      @user_term_1_chapters_studied = UserChapterProgress.where(user_id: current_user.id, chapter_id: chapter_ids_term_1)
      @user_term_2_chapters_studied = UserChapterProgress.where(user_id: current_user.id, chapter_id: chapter_ids_term_2)

      @term_1_studied = current_user.subject_studied(@term_1_chapters, @user_term_1_chapters_studied)
      @term_2_studied = current_user.subject_studied(@term_2_chapters, @user_term_2_chapters_studied)
      
      @term_1_spi = current_user.predictive_score_calculator(@term_1_chapters, @user_term_1_chapters_studied, [], [])
      @term_2_spi = current_user.predictive_score_calculator(@term_2_chapters, @user_term_2_chapters_studied, [], [])

    else
      @term_1_studied = 0
      @term_2_studied = 0
      @term_1_spi = 0
      @term_2_spi = 0
    end
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
      @subject = Subject.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subject_params
      params.require(:subject).permit(:name, :board, :standard, :slug)
    end
end
