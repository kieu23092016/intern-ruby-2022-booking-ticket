class StaticPagesController < ApplicationController
  def home
    @pagy, @movie_items = pagy Movie.all.sort_list,
                               items: Settings.digits.movie_per_page
  end
end
