class BookingsController < ApplicationController
  before_action :load_movie
  before_action :list_categories
  before_action :filter_date_showtime, only: %i(show)

  def new
    @movie = Movie.new
  end

  def show
    respond_to do |format|
      format.js
      format.html
    end
  end

  def date_filter; end

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

  def filter_date_showtime
    @cinemas = Cinema.all
    @show_date =  if params[:dateObj].nil?
                    DateTime.now.to_date.to_s
                  else
                    params[:dateObj]
                  end

    @show_times = ShowTime.filter_date(@movie.id,
                                       @show_date).group_by(&:room_id)
  end
end
