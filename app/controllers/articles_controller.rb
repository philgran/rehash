class ArticlesController < ApplicationController
  before_filter :ensure_site_exists
  before_filter :require_admin, :except => [:index, :show, :search]
  before_filter :find_article, :only => [:show, :edit, :update, :destroy]
  
  def index
    @articles = Article.all # converted from published named_scope due to friendly_id problems
    @articles.reject!{|a| !a.published} unless admin?
    respond_to do |format|
      format.html
      format.atom
    end
  end
  
  def show
    if @article && !@article.published?
      if admin?
        flash.now[:caution] = "Unpublished article"
        @article if admin?
      else
        flash.now[:error] = "Error"
      end
    end
  end
  
  def edit
  end
  
  def new
    @article = Article.new
  end
  
  def create
    @article = Article.new(params[:article])
    if @article.save
      flash[:notice] = "Create successful!"
      redirect_to @article
    else
      render 'new'
    end
  end
  
  def update
    if @article.update_attributes(params[:article])
      flash[:notice] = "Save successful!"
      redirect_to @article
    else
      render 'edit'
    end
  end
  
  def destroy
    if @article.destroy
      flash[:notice] = "Record deleted!"
      redirect_to articles_path
    else
      render 'edit'
    end
  end
  
  def search
    @articles = Article.search(params[:q])
    flash.now[:error] = "No results" if @articles.empty?
    render 'index'
  end
  
  def tagged
    # Article.published.find_tagged_with(params[:tag]) does not pass along named scope
    @articles = Article.find_tagged_with(params[:tag])
    @articles.reject!{|a| !a.published}
    flash.now[:error] = "No results" if @articles.empty?
    render 'index'
  end
  
  private
    def find_article
      @article = Article.find(params[:id])
    end
end