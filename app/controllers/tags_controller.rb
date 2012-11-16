class TagsController < ApplicationController
  before_filter :authenticate_user

  def show
    @user = current_user
    @tag = Tag.for_user(@user).find(params[:id])
    @monsters = @tag.monsters.for_user(@user)

    respond_to do |format|
      format.html { render '/monsters/index' }
      format.json { render json: @tag }
    end
  end

  private
  def authenticate_user
    return redirect_to :login unless current_user
  end
end
