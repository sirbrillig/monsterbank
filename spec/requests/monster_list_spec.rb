require 'spec_helper'

describe "Monster list" do

  before do
    @user = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user, :email=> 'monsterlisttestuser@test.com')
    visit login_path
    fill_in('email', :with => @user.email) 
    fill_in('password', :with => @user.password)
    click_button('Log In')
    Monster.destroy_all
    @mon1 = FactoryGirl.create(:level1_artillery, :name => 'testmonster', :user => @user)
    @mon2 = FactoryGirl.create(:level1_artillery, :role => 'Soldier', :name => 'a monster', :user => @user)
    @mon3 = FactoryGirl.create(:level1_artillery, :role => 'Soldier', :name => 'a monster 2', :user => @user2)
    @tag1 = FactoryGirl.create(:tag, :name => 'list tag1', :user => @user)
    @tag2 = FactoryGirl.create(:tag, :name => 'list tag2', :user => @user)
    @tag3 = FactoryGirl.create(:tag, :name => 'list tag3', :user => @user2)
    @tag1.monsters << @mon1 << @mon2
    @tag2.monsters << @mon1
    visit monsters_path
  end

  it "displays a list of Monsters" do
    page.should have_content "testmonster"
    page.should have_content "Artillery"
    page.should have_content "a monster"
    page.should have_content "Soldier"
  end

  it "does not display monsters belonging to another user" do
    page.should_not have_content @mon3.name
  end

  it "displays a list of Tags" do
    page.should have_content @tag1.name
    page.should have_content @tag2.name
  end

  it "does not display a tag belonging to another user" do
    page.should_not have_content @tag3.name
  end

  it "has a button to add a monster" do
    page.should have_link_to new_monster_path
  end

  context "when the star button is clicked" do
    before do
      @mon1.starred = false
      @mon1.save
      visit monsters_path
      click_link("star_monster_#{@mon1.id}")
    end
    
    it "changes the button to unstar" do
#       visit monsters_path #FIXME: this is done via ajax and shouldn't need a reload
      page.should have_css("#unstar_monster_#{@mon1.id}")
    end

    it "sets the monster to starred" do
      @mon1.reload
      @mon1.starred.should eq true
    end
  end

  context "when the unstar button is clicked" do
    before do
      @mon1.starred = true
      @mon1.save
      visit monsters_path
      click_link("unstar_monster_#{@mon1.id}")
    end

    it "changes the button to a star" do
#       visit monsters_path #FIXME: this is done via ajax and shouldn't need a reload
      page.should have_css("#star_monster_#{@mon1.id}")
    end

    it "sets the monster to unstarred" do
      @mon1.reload
      @mon1.starred.should eq false
    end
  end
end

