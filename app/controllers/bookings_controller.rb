class BookingsController < ApplicationController
  before_action :load_movie
  before_action :list_categories

  def new
    @movie = Movie.new
  end

  def show
    # @cinemas = Cinema.all
    # render json: Cinema.all
  end

  private

  def load_movie
    @movie = Movie.find_by id: params[:id]
    return if @movie

    flash[:error] = t "film_not_found"
    redirect_to root_path
  end

  def list_categories
    @categories = @movie.categories.pluck(:name)
  end
end
