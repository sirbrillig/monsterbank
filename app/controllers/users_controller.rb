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
    @user.password = 'foobar' #FIXME: ugh, hack. Ask the user for a password somehow.
    @user.password_confirmation = @user.password
    @monster = Monster.find(params[:monid])
    @user.monsters << @monster
    if @user.save
      redirect_to monster_path(@monster), :notice => "Your monster is saved!"
    else 
      redirect_to monster_path(@monster), :notice => "There was a problem with your email address: #{@user.errors.full_messages.join(', ')}"
    end
  end
end
