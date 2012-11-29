require 'spec_helper'

describe "The New Monster page" do
  before do
    visit new_monster_path
  end

  it "displays the form for creating a monster" do
    page.should have_field('monster[name]')
  end

  context "when logged-in and creating a monster" do
    before do
      Monster.destroy_all
      @user = FactoryGirl.create(:user)
      visit login_path
      fill_in('email', :with => @user.email) 
      fill_in('password', :with => @user.password)
      click_button('Log In')

      visit new_monster_path
      @mon = FactoryGirl.build(:monster, :name => 'hobbog_monster_name')
      fill_in('monster[name]', :with => @mon.name)
      click_button('Save this Monster')
    end

    it "redirects to the monster list page" do
      page.should have_normal_content("All Monsters")
    end

    it "shows the new monster" do
      page.should have_normal_content(@mon.name)
    end
  end

  context "when not logged-in and creating a monster" do
    before do
      @mon = FactoryGirl.build(:monster, :name => 'hobbog_monster_name_not_logged_in')
      fill_in('monster[name]', :with => @mon.name)
      click_button('Save this Monster')
    end

    it "does not have a log-out link" do
      page.should_not have_content 'Log Out'
    end

    context "and the monster name already exists" do
      context "and the duplicate monster belongs to a user" do
        before do
          @user = FactoryGirl.create(:user, :email => 'testbelongs_monster_notloggedin@test.com')
          @mon2 = FactoryGirl.create(:monster, :name => 'notloggedin_belongs', :user => @user)
          visit new_monster_path
          fill_in('monster[name]', :with => @mon2.name)
          click_button('Save this Monster')
        end

        it "redirects to the show monster page" do
          page.should have_normal_content("Save this Monster for Later")
        end
      end

      context "and the duplicate monster belongs to no one" do
        before do
          @mon3 = FactoryGirl.create(:monster, :name => 'notloggedin_not_belongs', :user => nil)
          visit new_monster_path
          fill_in('monster[name]', :with => @mon3.name)
          click_button('Save this Monster')
        end

        it "gives an error" do
          page.should have_field 'monster[name]'
        end
      end
    end

    context "and the monster name does not exist" do
      it "redirects to the show monster page" do
        page.should have_normal_content("Save this Monster for Later")
      end

      it "shows the new monster" do
        page.should have_normal_content(@mon.name)
      end
    end
  end
end
