class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to root_url, :notice => "You are signed-up!"
    else 
      render "new"
    end
  end

  def save_monster
    @user = User.new(params[:user])
    @monster = Monster.find(params[:monid])
    @user.monsters << @monster
    if @user.save
      # FIXME: send an email with a link
      redirect_to monster_path(@monster), :notice => "Your monster is saved and has been sent to your email address."
    else 
      redirect_to monster_path(@monster), :notice => "Your monster is saved and has been sent to your email address."
    end
  end
end
