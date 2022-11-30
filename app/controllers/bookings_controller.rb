class BookingsController < ApplicationController
  before_action :load_movie
  before_action :list_categories

  def new
    @movie = Movie.new
  end

  def show
    render json: {
      movie: @movie, 
      cinemas: Cinema.all
    }
  end

  private

  def load_movie
    @movie = Movie.find_by id: params[:id]
    return if @movie

    render json: {}, status: :not_found
  end

  def list_categories
    @categories = @movie.categories.pluck(:name)
  end
end
