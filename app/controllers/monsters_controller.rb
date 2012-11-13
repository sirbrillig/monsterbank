class MonstersController < ApplicationController
  before_filter :authenticate_user, :except => [:new, :show, :create]

  # GET /monsters
  # GET /monsters.json
  def index
    @user = current_user
    @monsters = @current_user.monsters

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @monsters }
    end
  end

  # GET /monsters/1
  # GET /monsters/1.json
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

  # GET /monsters/new
  # GET /monsters/new.json
  def new
    @monster = Monster.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @monster }
    end
  end

  # GET /monsters/1/edit
  def edit
    @monster = Monster.for_user(current_user).find(params[:id]) # Note that this creates a JOIN and is therefore ReadOnly.
  end

  # POST /monsters
  # POST /monsters.json
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

  # PUT /monsters/1
  # PUT /monsters/1.json
  def update
    @monster = Monster.find(:first, :conditions => { :id => params[:id], :user_id => current_user.id })

    respond_to do |format|
      if @monster.update_attributes(params[:monster])
        if params[:new_tag_button] and params[:new_tag]
          @monster.tags << Tag.create(:name => params[:new_tag], :user => current_user)
          format.html { render action: "edit" }
          format.json { head :no_content }
        else
          format.html { redirect_to @monster, notice: 'Monster was successfully updated.' }
          format.json { head :no_content }
        end
      else
        format.html { render action: "edit" }
        format.json { render json: @monster.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /monsters/1
  # DELETE /monsters/1.json
  def destroy
    @monster = Monster.find(:first, :conditions => { :id => params[:id], :user_id => current_user.id })
    @monster.destroy

    respond_to do |format|
      format.html { redirect_to monsters_url, notice: 'Monster has been deleted.' }
      format.json { head :no_content }
    end
  end

  private
  def authenticate_user
    return redirect_to :login unless current_user
  end
end
