class Admin::ShowTimesController < AdminController
  before_action :find_movie

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
      flash[:danger] = @show_time.errors[:start_time].to_sentence
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

    flash[:danger] = t "film_not_found"
    redirect_to admin_movies_path
  end
end
