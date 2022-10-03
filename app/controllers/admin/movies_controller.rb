class Admin::MoviesController < AdminController
  before_action :find_movie, except: %i(index new create)
  before_action :list_categories, only: :show

  rescue_from ActiveRecord::DeleteRestrictionError, with: :error_del_method
  def error_del_method
    flash[:error] = t "not_del"
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
    @movie.image.attach(params[:movie][:image])

    if @movie.save
      flash[:success] = t "updated"
      redirect_to admin_movie_path(id: @movie.id)
    else
      flash[:error] = t "not_updated"
      render :new
    end
  end

  def edit; end

  def update
    if @movie.update movie_params
      flash[:success] = t "changed"
      redirect_to admin_movie_path(id: @movie.id)
    else
      flash[:error] = t "not_changed"
      render :edit
    end
  end

  def destroy
    if @movie.destroy
      flash[:success] = t "deleted"
      redirect_to request.referer || admin_movies_path
    else
      flash[:error] = t "not_deleted"
      redirect_to admin_movies_path
    end
  end

  private

  def movie_params
    params.require(:movie).permit(Movie::MOVIE_ATTRS, category_ids: [],
                                  movie_categories_attributes:
                                      [:id, :movie_id, :category_id])
  end

  def find_movie
    @movie = Movie.find_by id: params[:id]
    return if @movie

    flash[:error] = t "film_not_found"
    redirect_to admin_root_path
  end

  def list_categories
    @categories = @movie.categories.pluck(:name)
  end
end
