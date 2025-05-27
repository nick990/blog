class AuthorsController < ApplicationController
  before_action :set_author, only: [ :show, :update, :destroy ]

  def index
    @authors = Author.all
    render json: @authors
  end

  def show
    render json: @author
  end

  def create
    @author = Author.new(author_params)
    if @author.save
      render json: @author, status: :created
    else
      render json: @author.errors, status: :unprocessable_entity
    end
  end

  def update
    if @author.update(author_params)
      render json: @author
    else
      render json: @author.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @author.destroy
  end

  private

  def author_params
    params.require(:author).permit(:name)
  end

  def set_author
    @author = Author.find(params[:id])
  end
end
