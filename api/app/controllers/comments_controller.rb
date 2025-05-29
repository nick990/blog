class CommentsController < ApplicationController
  before_action :set_article
  before_action :set_comment, only: [ :show, :destroy ]
  def index
    @comments = @article.comments.order(sorting_params_parsed)
    filtering_params_parsed.each do |key, value|
      @comments = @comments.where(key => value)
    end
    render json: CommentSerializer.new(@comments).serializable_hash
  end

  def show
    render json: CommentSerializer.new(@comment).serializable_hash
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
    @comment.destroy
  end

  private

  def set_article
    @article = Article.find(params[:article_id])
  end

  def set_comment
    @comment = @article.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:commenter, :body)
  end
end
