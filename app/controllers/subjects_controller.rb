class SubjectsController < ApplicationController
  before_action :set_subject, only: [:show, :edit, :update, :destroy]
  before_action :validate_admin, except: [:show, :improve_predictive_score]
  before_action :validate_user, only: [:improve_predictive_score]

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

      @user_term_payment = [current_user.term_1_payment, current_user.term_2_payment]
      
      @term_1_weight = term_weight(@term_1_chapters)
      @term_2_weight = term_weight(@term_2_chapters)

      @user_term_1_chapters_studied = UserChapterProgress.where(user_id: current_user.id, chapter_id: chapter_ids_term_1)
      @user_term_2_chapters_studied = UserChapterProgress.where(user_id: current_user.id, chapter_id: chapter_ids_term_2)

      @term_1_studied = subject_studied(@term_1_chapters, @user_term_1_chapters_studied)
      @term_2_studied = subject_studied(@term_2_chapters, @user_term_2_chapters_studied)

      @user_term_1_mock_fas = AssessmentMockFa.where(user_id: current_user.id, subject_id: @subject.id, term: 1)
      @user_term_2_mock_fas = AssessmentMockFa.where(user_id: current_user.id, subject_id: @subject.id, term: 2)
      
      @user_term_1_mock_fas_in_progress = 0
      @user_term_2_mock_fas_in_progress = 0

      @user_term_1_mock_sas = AssessmentMockSa.where(user_id: current_user.id, subject_id: @subject.id, term: "1")
      @user_term_2_mock_sas = AssessmentMockSa.where(user_id: current_user.id, subject_id: @subject.id, term: "2")
      
      @user_term_1_mock_sas_in_progress = 0
      @user_term_2_mock_sas_in_progress = 0
      
      @term_1_spi = predictive_score_calculator(@term_1_chapters, @user_term_1_chapters_studied, @user_term_1_mock_fas, @user_term_1_mock_sas)
      @term_2_spi = predictive_score_calculator(@term_2_chapters, @user_term_2_chapters_studied, @user_term_2_mock_fas, @user_term_2_mock_sas)

    else
      @user_term_payment = [0,0]
      @term_1_studied = 0
      @term_2_studied = 0
      @term_1_spi = 0
      @term_2_spi = 0
      @user_term_1_mock_fas = 0
      @user_term_2_mock_fas = 0
      @user_term_1_mock_fas_in_progress = 0
      @user_term_2_mock_fas_in_progress = 0
      @user_term_1_mock_sas = 0
      @user_term_2_mock_sas = 0
      @user_term_1_mock_sas_in_progress = 0
      @user_term_2_mock_sas_in_progress = 0
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
      
      @user_term_payment = [current_user.term_1_payment, current_user.term_2_payment]
      
      @user_term_1_chapters_studied = UserChapterProgress.where(user_id: current_user.id, chapter_id: chapter_ids_term_1)
      @user_term_2_chapters_studied = UserChapterProgress.where(user_id: current_user.id, chapter_id: chapter_ids_term_2)

      @term_1_studied = subject_studied(@term_1_chapters, @user_term_1_chapters_studied)
      @term_2_studied = subject_studied(@term_2_chapters, @user_term_2_chapters_studied)

      @user_term_1_mock_fas = AssessmentMockFa.where(user_id: current_user.id, subject_id: @subject.id, term: 1)
      @user_term_2_mock_fas = AssessmentMockFa.where(user_id: current_user.id, subject_id: @subject.id, term: 2)
      
      @user_term_1_mock_fas_in_progress = 0
      @user_term_2_mock_fas_in_progress = 0

      @user_term_1_mock_sas = AssessmentMockSa.where(user_id: current_user.id, subject_id: @subject.id, term: "1")
      @user_term_2_mock_sas = AssessmentMockSa.where(user_id: current_user.id, subject_id: @subject.id, term: "2")
      
      @user_term_1_mock_sas_in_progress = 0
      @user_term_2_mock_sas_in_progress = 0
      
      @term_1_spi = predictive_score_calculator(@term_1_chapters, @user_term_1_chapters_studied, @user_term_1_mock_fas, @user_term_1_mock_sas)
      @term_2_spi = predictive_score_calculator(@term_2_chapters, @user_term_2_chapters_studied, @user_term_2_mock_fas, @user_term_2_mock_sas)


    else
      @user_term_payment = [0,0]
      @term_1_studied = 0
      @term_2_studied = 0
      @term_1_spi = 0
      @term_2_spi = 0
      @user_term_1_mock_fas = 0
      @user_term_2_mock_fas = 0
      @user_term_1_mock_fas_in_progress = 0
      @user_term_2_mock_fas_in_progress = 0
      @user_term_1_mock_sas = 0
      @user_term_2_mock_sas = 0
      @user_term_1_mock_sas_in_progress = 0
      @user_term_2_mock_sas_in_progress = 0
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
