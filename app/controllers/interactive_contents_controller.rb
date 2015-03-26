class InteractiveContentsController < ApplicationController
  before_action :set_interactive_content, only: [:show, :edit, :update, :destroy]

  def index
    @interactive_contents = InteractiveContent.all
  end

  def show
  end

  def new
    @interactive_content = InteractiveContent.new
  end

  def edit
  end

  def create
    @interactive_content = InteractiveContent.new(interactive_content_params)

    respond_to do |format|
      if @interactive_content.save
        format.html { redirect_to @interactive_content, notice: 'Interactive content was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @interactive_content.update(interactive_content_params)
        format.html { redirect_to @interactive_content, notice: 'Interactive content was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @interactive_content.destroy
    respond_to do |format|
      format.html { redirect_to interactive_contents_url }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_interactive_content
      @interactive_content = InteractiveContent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def interactive_content_params
      params.require(:interactive_content).permit(:content_type, :name, :content, :production_date, :producer_name, :admin_note)
    end
end
