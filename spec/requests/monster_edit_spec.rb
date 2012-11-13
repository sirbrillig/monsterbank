require 'spec_helper'

describe "Edit Monster page" do
  before :each do
    Monster.destroy_all
    @user = FactoryGirl.create(:user)
    visit login_path
    fill_in('email', :with => @user.email) 
    fill_in('password', :with => @user.password)
    click_button('Log In')
    @mon = FactoryGirl.create(:level1_artillery, :user => @user)
  end

  it "displays Monster name, level, and role" do
    visit edit_monster_path(@mon.id)
    page.should have_field('monster[name]', :value => @mon.name)
    page.should have_field('monster[level]', :value => @mon.level)
    page.should have_field('monster[role]', :value => @mon.role)
  end

  context "when changing the level" do
    before :each do 
      visit edit_monster_path(@mon.id)
      fill_in('monster[level]', :with => 12)
    end

    it "redirects to the show page" do
      click_button('Save')
      page.should_not have_field('monster[level]')
    end

    it "updates the level" do
      click_button('Save')
      page.should have_normal_content "Level: 12"
    end

    it "fails if the level is 0" do
      fill_in('monster[level]', :with => 0)
      click_button('Save')
      page.should have_field('monster[level]')
      page.should have_content 'Level must be greater than'
    end

    it "fails if the level is greater than 30" do
      fill_in('monster[level]', :with => 100)
      click_button('Save')
      page.should have_field('monster[level]')
      page.should have_content 'Level must be less than'
    end

    it "fails if the level is negative" do
      fill_in('monster[level]', :with => -5)
      click_button('Save')
      page.should have_field('monster[level]')
      page.should have_content 'Level must be greater than'
    end
  end

  context "when changing the role" do
    before :each do 
      visit edit_monster_path(@mon.id)
      select('Skirmisher', :from => 'monster[role]')
    end

    it "redirects to the show page" do
      click_button('Save')
      page.should_not have_field('monster[role]')
    end

    it "updates the role" do
      click_button('Save')
      page.should have_normal_content 'Role: Skirmisher'
    end
  end

  context "when changing the subrole to Elite" do
    before :each do 
      visit edit_monster_path(@mon.id)
      select('Elite', :from => 'monster[subrole]')
    end

    it "redirects to the show page" do
      click_button('Save')
      page.should_not have_field('monster[subrole]')
    end

    it "updates the subrole to Elite" do
      click_button('Save')
      page.should have_normal_content 'Role: Elite'
    end
  end

  context "when changing the subrole to Solo" do
    before :each do 
      visit edit_monster_path(@mon.id)
      select('Elite', :from => 'monster[subrole]')
    end

    it "redirects to the show page" do
      click_button('Save')
      page.should_not have_field('monster[subrole]')
    end

    it "updates the subrole to Elite" do
      click_button('Save')
      page.should have_normal_content 'Role: Elite'
    end
  end

  context "when changing the name" do
    before :each do 
      visit edit_monster_path(@mon.id)
      fill_in('monster[name]', :with => "testmonster_name_change_#{Time.now.to_i}")
    end

    it "redirects to the show page" do
      click_button('Save')
      page.should_not have_field('monster[name]')
    end

    it "updates the name" do
      click_button('Save')
      page.should have_normal_content "Name: testmonster_name_change_"
    end

    it "fails if the name is blank" do
      fill_in('monster[name]', :with => "")
      click_button('Save')
      page.should have_field('monster[name]')
      page.should have_content "Name can't be blank"
    end

    it "fails if the name is a duplicate" do
      mon = FactoryGirl.create(:monster, :user => @user)
      fill_in('monster[name]', :with => mon.name)
      click_button('Save')
      page.should have_field('monster[name]')
      page.should have_content "Name has already been taken"
    end
  end

  context "when deleting a Monster" do
    it "should confirm the deletion" do
      visit edit_monster_path(@mon.id)
      click_button('Delete This Monster')
      page.should have_content "has been deleted"
    end
  end
end # Edit Monster page
