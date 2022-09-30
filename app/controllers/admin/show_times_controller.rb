class Admin::ShowTimesController < AdminController
  before_action :find_movie
  before_action :find_showtime, only: %i(edit update destroy)

  rescue_from ActiveRecord::DeleteRestrictionError, with: :error_del_method
  def error_del_method
    flash[:error] = t "seats"
    redirect_to admin_movie_show_times_path
  end

  def index
    @show_times = @movie.show_times
  end

  def new
    @show_time = ShowTime.new
  end

  def create
    @show_time = @movie.show_times.build showtime_params

    if @show_time.save
      flash[:success] = t "st_updated"
    else
      flash[:error] = @show_time.errors[:start_time].to_sentence
    end

    redirect_to admin_movie_show_times_path
  end

  def edit; end

  def update
    if @show_time.update showtime_params
      flash[:success] = t "changed"
      redirect_to admin_movie_show_times_path
    else
      flash[:error] = @show_time.errors[:seats].to_sentence
      render :edit
    end
  end

  def destroy
    if @show_time.destroy
      flash[:success] = t "deleted"
    else
      flash[:error] = t "not_deleted"
    end

    redirect_to admin_movie_show_times_path
  end

  private

  def showtime_params
    params.require(:show_time).permit(:start_time, :room_id)
  end

  def find_movie
    @movie = Movie.find_by(id: params[:movie_id])
    return if @movie

    flash[:error] = t "film_not_found"
    redirect_to admin_movies_path
  end

  def find_showtime
    @show_time = ShowTime.find_by(id: params[:id])
    return if @show_time

    flash[:error] = t "showtime_not_found"
    redirect_to admin_movie_show_times_path
  end
end
