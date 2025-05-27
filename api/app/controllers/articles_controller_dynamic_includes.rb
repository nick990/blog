class ArticlesController < ApplicationController
  before_action :set_includes, only: [ :index, :show ]
  before_action :set_article, only: [ :show,  :update, :destroy ]

  def index
    @articles = Article.all
    @articles = @articles.includes(@includes)
    render json: @articles,
          include_list:  @includes
    # adapter: :json_api
  end

  def show
    render json: @article,
           include_list:  @includes
    #  adapter: :json_api
  end

  def create
    @article = Article.new(article_params)
    if @article.save
      render json: @article, status: :created, location: @article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  def update
    if @article.update(article_params)
      render json: @article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @article.destroy
  end

  private

  def set_article
    @article = Article.includes(@includes).find(params[:id])
  end

  def set_includes
    @includes = params[:include]&.split(",")&.map(&:to_sym) || []
  end

  def article_params
    params.require(:article).permit(:title, :body, :author_id)
  end

end
