class AuthorsController < ApplicationController
  before_action :set_author, only: [ :show, :update, :destroy ]
  
  sortable default: {name: :asc}
  
  def index
    @authors = Author.all.order(sorting_params_parsed)
    filtering_params_parsed.each do |key, value|
      operator = value.keys.first
      filter_value = value[operator]
      case operator
        when :eq
          @authors = @authors.where(key => filter_value)
        when :neq
          @authors = @authors.where.not(key => filter_value)   
      end
    end
    render json: AuthorSerializer.new(@authors).serializable_hash
  end

  def show
    render json: AuthorSerializer.new(@author).serializable_hash
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
