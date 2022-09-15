class BookingsController < ApplicationController
  def new
    @movie = Movie.new
  end

  def show
    @movie = Movie.find_by id: params[:id]
    return if @movie

    flash[:danger] = t "film_not_found"
    redirect_to root_path
  end
end
