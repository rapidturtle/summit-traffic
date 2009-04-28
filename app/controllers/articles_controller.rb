class ArticlesController < ApplicationController
  
  before_filter { |c| c.send :set_page_title, ['News'] }
  before_filter :login_required, :except => [:index, :ticker, :show]
  
  caches_page :index, :ticker, :show, :new
  cache_sweeper :article_sweeper, :only => [:create, :update, :destroy]
  
  # GET /articles
  def index
    @articles = Article.current
  end
  
  # GET /articles/ticker
  def ticker
    @articles = Article.current(:limit => 5)
    respond_to do |format|
      format.rss # /articles/ticker.rss
    end
  end
  
  # GET /articles/:id
  def show
    @article = Article.find(params[:id])
    @page_title << @article.title
  end
  
  # GET /articles/new
  def new
    @article = Article.new
  end
  
  # GET /articles/:id/edit
  def edit
    @article = Article.find(params[:id])
  end
  
  # POST /articles
  def create
    @article = Article.new(params[:article])
    
    if @article.save
      flash[:notice] = "<em>#{@article.title}</em> was successfully created."
      redirect_to articles_path
    else
      render :action => 'new'
    end
  end
  
  # PUT /articles/:id
  def update
    @article = Article.find(params[:id])
    
    if @article.update_attributes(params[:article])
      flash[:notice] = "<em>#{@article.title}</em> was successfully updated."
      redirect_to articles_path
    else
      render :action => 'edit'
    end
  end
  
  # DELETE /articles/:id
  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    
    redirect_to articles_path
  end

end
