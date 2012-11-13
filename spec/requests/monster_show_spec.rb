require 'spec_helper'

describe "Monster page" do
  context "when not logged-in" do
    before do
      @mon = FactoryGirl.create(:monster, :name => 'notloggedin monster')
    end

    context "and the monster is owned by a user" do
      before do
        @user = FactoryGirl.create(:user, :email => 'owninguser@test.com')
        @mon.user = @user
        @mon.save
        visit monster_path(@mon)
      end

      it "displays a log-in form" do
        page.should have_field('user[email]')
        page.should have_field('user[password]')
        page.should have_button('Log In')
      end
      
      it "redirects to the monster view when log-in is complete" do
        fill_in('email', :with => @user.email) 
        fill_in('password', :with => @user.password)
        click_button('Log In')
        page.should have_normal_content "Name: #{@mon.name}"
      end
    end

    context "and the monster is not owned by a user" do
      before do
        @mon.user = nil
        @mon.save
        visit monster_path(@mon)
      end

      it "displays a 'save this monster' form with an email field" do
        page.should have_field('user[email]')
        page.should have_button('Save')
      end
    end
  end

  context "when logged-in" do
    before do
      @user = FactoryGirl.create(:user)
      visit login_path
      fill_in('email', :with => @user.email) 
      fill_in('password', :with => @user.password)
      click_button('Log In')
    end


    context "with a level 1 Artillery Monster" do
      before :each do
        @mon = FactoryGirl.create(:level1_artillery, :user => @user)
      end

      it "displays Monster name, level, and role" do
        visit monster_path(@mon)
        page.should have_normal_content "Name: #{@mon.name}"
        page.should have_normal_content "Level: #{@mon.level}"
        page.should have_normal_content "Role: #{@mon.role}"
      end

      it "displays Monster XP" do
        visit monster_path(@mon)
        page.should have_normal_content "XP: 100"
      end
    end

    context "with a level 1 Elite Artillery Monster" do
      before :each do
        @mon = FactoryGirl.create(:level1_elite_artillery, :user => @user)
      end

      it "displays Elite subrole" do
        visit monster_path(@mon)
        page.should have_normal_content 'Role: Elite Artillery'
      end

      it "displays double XP for a Elite" do
        visit monster_path(@mon)
        page.should have_normal_content 'XP: 200'
      end
    end
  end
end
