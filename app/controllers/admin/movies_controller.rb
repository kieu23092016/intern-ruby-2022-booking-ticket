class Admin::MoviesController < AdminController
  before_action :find_movie, except: %i(index new create)

  rescue_from ActiveRecord::DeleteRestrictionError, with: :error_del_method
  def error_del_method
    flash[:danger] = t "not_del"
    redirect_to admin_movies_path
  end

  def index
    @pagy, @movies = pagy Movie.sort_list,
                          items: Settings.digits.admin_movie_per_page
  end

  def show; end

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

  def edit; end

  def update
    if @movie.update movie_params
      flash[:success] = t "changed"
      redirect_to admin_movie_path(id: @movie.id)
    else
      flash[:danger] = t "not_changed"
      render :edit
    end
  end

  def destroy
    if @movie.destroy
      flash[:success] = t "deleted"
      redirect_to request.referer || admin_movies_path
    else
      flash[:danger] = t "not_deleted"
      redirect_to admin_movies_path
    end
  end

  private

  def movie_params
    params.require(:movie).permit(Movie::MOVIE_ATTRS)
  end

  def find_movie
    @movie = Movie.find_by id: params[:id]
    return if @movie

    flash[:danger] = t "film_not_found"
    redirect_to admin_root_path
  end
end
