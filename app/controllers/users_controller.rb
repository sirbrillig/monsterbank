class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    if current_user
      @user = @current_user = current_user
    else
      unless @user = User.find(params[:user][:id])
        @user = User.new(params[:user])
      end
    end

    if params[:monid]
      @monster = Monster.find(params[:monid])
      raise "No such monster" unless @monster
      raise "That monster is already owned." if @monster.user
      @user.monsters << @monster
    end

    if @user.save
      session[:user_id] = @user.id
      if @monster
        redirect_to monsters_path, :notice => "Your monster has been saved!"
      else
        redirect_to root_url, :notice => "You are signed-up!"
      end
    else 
      # Save failed...
      if @monster
        render "save_monster"
      else
        render "new"
      end
    end
  end

  def save_monster
    @current_user = current_user
    if @current_user
      @user = current_user
    else
      unless @user = User.find_by_email(params[:user][:email]) 
        @user = User.new(params[:user])
      end
    end
    @monster = Monster.find(params[:monid])
  end
end
