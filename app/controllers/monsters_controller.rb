class MonstersController < ApplicationController
  before_filter :authenticate_user, :except => [:new, :show, :create]

  def index
    @user = current_user
    @monsters = @current_user.monsters

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @monsters }
    end
  end

  def starred
    @user = current_user
    @monsters = @current_user.monsters.select { |monster| monster.starred }
    @starred = true

    respond_to do |format|
      format.html { render 'index' }
      format.json { render json: @monsters }
    end
  end

  def show
    @current_user = current_user
    if @current_user
      @monster = Monster.for_user(@current_user).find(params[:id])
    else
      if @monster = Monster.find(params[:id])
        if @monster.user
        else
          @user = User.new
        end
      end
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @monster }
    end
  end

  def new
    @monster = Monster.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @monster }
    end
  end

  def edit
    @monster = Monster.for_user(current_user).find(params[:id]) # Note that this creates a JOIN and is therefore ReadOnly.
  end

  def create
    @monster = Monster.new(params[:monster])
    @monster.user = current_user if current_user

    respond_to do |format|
      if @monster.save
        format.html { redirect_to @monster, notice: 'Monster was successfully created.' }
        format.json { render json: @monster, status: :created, location: @monster }
      else
        format.html { render action: "new" }
        format.json { render json: @monster.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @monster = Monster.find(:first, :conditions => { :id => params[:id], :user_id => current_user.id })

    respond_to do |format|
      if @monster.update_attributes(params[:monster])
        if params[:new_tag_button] and params[:new_tag]
          @monster.tags << Tag.find_or_create_by_name(:name => params[:new_tag], :user => current_user)
          format.html { redirect_to edit_monster_path(@monster)}
          format.js
        else
          format.html { redirect_to monsters_path, notice: 'Monster was successfully updated.' }
        end
      else
        format.html { render action: "edit" }
        format.json { render json: @monster.errors, status: :unprocessable_entity }
      end
    end
  end

  def delete_tag
    @monster = Monster.find(:first, :conditions => { :id => params[:id], :user_id => current_user.id })

    respond_to do |format|
      tag = Tag.find(:first, :conditions => {:id => params[:tag], :user_id => current_user.id})
      if @monster and tag
        tag.remove_monster(@monster)
        format.html { render action: "edit" }
        format.js
      else
        format.html { render action: "edit" }
        format.json { render json: @monster.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @monster = Monster.find(:first, :conditions => { :id => params[:id], :user_id => current_user.id })
    @monster.destroy

    respond_to do |format|
      format.html { redirect_to monsters_url, notice: 'Monster has been deleted.' }
      format.json { head :no_content }
    end
  end

  def star
    @monster = Monster.find(:first, :conditions => { :id => params[:id], :user_id => current_user.id })
    @monster.starred = !@monster.starred
    @monster.save

    respond_to do |format|
      format.html { redirect_to monsters_url }
      format.js
    end
  end

  private
  def authenticate_user
    return redirect_to :login unless current_user
  end
end
