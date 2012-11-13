class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    if params[:monid]
      @monster = Monster.find(params[:monid])
      @user.monsters << @monster
    end

    if @user.save
      session[:user_id] = @user.id
      if @monster
        redirect_to monster_path(@monster), :notice => "Your monster has been saved!"
      else
        redirect_to root_url, :notice => "You are signed-up!"
      end
    else 
      if @monster
        render "save_monster"
      else
        render "new"
      end
    end
  end

  def save_monster
    @user = User.new(params[:user])
    @monster = Monster.find(params[:monid])
  end
end
