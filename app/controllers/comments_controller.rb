class CommentsController < ApplicationController
  load_and_authorize_resource
  def create
    @comment = Comment.create(movie_id: params[:booking_id],
                              user_id: current_user.id,
                              content: params[:content])
    if @comment
      flash[:success] = t("comment_created")
    else
      flash[:danger] = t("comment_failed")
    end

    redirect_to booking_path(id: params[:booking_id]), id: "comment-part"
  end
end
