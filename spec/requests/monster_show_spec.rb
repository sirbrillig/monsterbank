require 'spec_helper'

describe "Monster page" do
  before do
    @user = FactoryGirl.create(:user)
    visit login_path
    fill_in('email', :with => @user.email) 
    fill_in('password', :with => @user.password)
    click_button('Log In')
  end

  context "when not logged-in" do
    context "when the monster is owned by a user" do
      it "displays a log-in form"
      
      it "redirects to the monster view when log-in is complete"
    end

    context "when the monster is not owned by a user" do
      it "displays a 'save this monster' form with an email field"
    end
  end

  context "with a level 1 Artillery Monster" do
    before :each do
      @mon = FactoryGirl.create(:level1_artillery, :user => @user)
    end

    it "displays Monster name, level, and role" do
      visit monster_path(@mon.id)
      page.should have_normal_content "Name: #{@mon.name}"
      page.should have_normal_content "Level: #{@mon.level}"
      page.should have_normal_content "Role: #{@mon.role}"
    end

    it "displays Monster XP" do
      visit monster_path(@mon.id)
      page.should have_normal_content "XP: 100"
    end
  end

  context "with a level 1 Elite Artillery Monster" do
    before :each do
      @mon = FactoryGirl.create(:level1_elite_artillery, :user => @user)
    end

    it "displays Elite subrole" do
      visit monster_path(@mon.id)
      page.should have_normal_content 'Role: Elite Artillery'
    end

    it "displays double XP for a Elite" do
      visit monster_path(@mon.id)
      page.should have_normal_content 'XP: 200'
    end
  end
end # Monster page

