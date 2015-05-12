class ContentTagsController < ApplicationController
  before_action :set_content_tag, only: [:show, :edit, :update, :destroy]
  before_action :validate_admin

  def index
    @content_tags = ContentTag.all
  end

  def show
  end

  def new
    @content_tag = ContentTag.new
  end

  def edit
  end

  def create
    @content_tag = ContentTag.new(content_tag_params)

    respond_to do |format|
      if @content_tag.save
        format.html { redirect_to content_tags_url, notice: 'Content tag was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @content_tag.update(content_tag_params)
        format.html { redirect_to content_tags_url, notice: 'Content tag was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @content_tag.destroy
    respond_to do |format|
      format.html { redirect_to content_tags_url }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_content_tag
      @content_tag = ContentTag.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def content_tag_params
      params.require(:content_tag).permit(:tag_name, :tag_type)
    end
end
