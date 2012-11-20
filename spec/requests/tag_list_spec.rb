require 'spec_helper'

describe "List of Monsters" do
  before do
    @user = FactoryGirl.create(:user, :email => 'taglisttest1@test.com')
    @user2 = FactoryGirl.create(:user, :email=> 'taglisttest2@test.com')
    @tag = FactoryGirl.create(:tag, :name => 'taglisttesttag', :user => @user)
    visit login_path
    fill_in('email', :with => @user.email) 
    fill_in('password', :with => @user.password)
    click_button('Log In')
    Monster.destroy_all
    @mon1 = FactoryGirl.create(:monster, :role => 'Artillery', :name => 'tagtestmonster1', :user => @user, :starred => true)
    @mon2 = FactoryGirl.create(:monster, :role => 'Soldier', :name => 'tagtestmonster2', :user => @user, :starred => true)
    @mon3 = FactoryGirl.create(:monster, :role => 'Soldier', :name => 'tagtestmonster3', :user => @user2, :starred => true)
    @mon4 = FactoryGirl.create(:monster, :role => 'Controller', :name => 'tagtestmonster4', :user => @user, :starred => false)
    @tag.monsters << @mon1 << @mon3 << @mon4
  end

  describe "Starred list" do
    before do
      visit starred_path
    end

    it "lists all the monsters with a star" do
      page.should have_content @mon1.name
      page.should have_content @mon2.name
    end

    it "does not list a monster without a star" do
      page.should_not have_content @mon4.name
    end

    it "does not list a monster with a star belonging to another user" do
      page.should_not have_content @mon3.name
    end

    it "shows a link to the full monster list" do
      page.should have_link_to monsters_path
    end
  end

  describe "Tag list" do
    before do
      visit tag_path(@tag)
    end

    it "displays the name of the tag" do
      page.should have_content @tag.name
    end

    it "lists all the monsters with that tag" do
      page.should have_content @mon1.name
      page.should have_content @mon4.name
    end

    it "does not list a monster without that tag" do
      page.should_not have_content @mon2.name
    end

    it "does not list a monster with that tag belonging to another user" do
      page.should_not have_content @mon3.name
    end

    it "shows a link to the full monster list" do
      page.should have_link_to monsters_path
    end
  end
end
