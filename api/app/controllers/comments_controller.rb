class CommentsController < ApplicationController
  before_action :set_article

  def index
    @comments = @article.comments
    render json: @comments
  end

  def show
    @comment = @article.comments.find(params[:id])
    render json: @comment
  end

  def create
    @comment = @article.comments.new(comment_params)
    if @comment.save
      render json: @comment, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @comment = @article.comments.find(params[:id])
    @comment.destroy
  end

  private

  def set_article
    @article = Article.find(params[:article_id])
  end

  def comment_params
    params.require(:comment).permit(:commenter, :body)
  end
end
