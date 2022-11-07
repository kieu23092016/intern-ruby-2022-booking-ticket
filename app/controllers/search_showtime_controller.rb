class SearchShowtimeController < ApplicationController
  def index
    @filter_showtime = ShowTime.ransack({filter_date: [params[:movie_id],
params[:start_time]]})
    @show_times = @filter_showtime.result.group_by(&:room_id)
    @cinemas = Cinema.all
    respond_to do |format|
      format.js
      format.html
    end
  end

  def set_ransack_auth_object
    current_user.present? ? :admin : :user
  end
end
