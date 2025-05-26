class ArticlesController < ApplicationController
  before_action :set_article, only: [ :show,  :update, :destroy ]
  def index
    @articles = Article.all
    includes = params_includes
    Rails.logger.info "Controller includes: #{includes.inspect}"
    @articles = @articles.includes(includes) if includes.any?
    render json: @articles,
          include_list:  includes
    # adapter: :json_api
  end

  def show
    includes = params_includes
    Rails.logger.info "Controller includes: #{includes.inspect}"
    render json: @article,
           include_list:  includes
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
    includes = params_includes
    @article = Article.includes(includes).find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :body)
  end

  # TODO:
  # - definire var instanza
  # - definire un meccanismo simile a strong parameters per i parametri di include
  def params_includes
    params[:include]&.split(",")&.map(&:to_sym) || []
  end
end
