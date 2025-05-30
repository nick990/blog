class ArticlesController < ApplicationController
  before_action :set_article, only: [ :show,  :update, :destroy ]

  def index
    @articles = Article.all.order(sorting_params_parsed)
    @articles = filter_entities(@articles)
    render json: ArticleSerializer.new(@articles).serializable_hash
  end

  def show
    render json: ArticleSerializer.new(@article).serializable_hash
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
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :body, :author_id)
  end

end
