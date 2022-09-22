class Admin::MoviesController < AdminController
  def index
    @pagy, @movies = pagy Movie.sort_list,
                          items: Settings.digits.admin_movie_per_page
  end

  def show
    @movie = Movie.find_by id: params[:id]
    return if @movie

    flash[:danger] = t "film_not_found"
    redirect_to admin_root_path
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new movie_params

    if @movie.save
      flash[:success] = t "updated"
      redirect_to admin_movie_path(id: @movie.id)
    else
      flash[:danger] = t "not_updated"
      redirect_to admin_movies_path
    end
  end

  private

  def movie_params
    params.require(:movie).permit(Movie::MOVIE_ATTRS)
  end
end
