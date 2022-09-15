class TicketsController < ApplicationController
  before_action :load_show_time
  def show
    @room = @show_time.room
    @tickets = @show_time.tickets
    @movie = @show_time.movie
  end

  private

  def load_show_time
    @show_time = ShowTime.find_by id: params[:id]
    return if @show_time

    flash[:danger] = t "show_time_not_found"
    redirect_to root_path
  end
end
