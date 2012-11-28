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

    it "redirects to the show monster page" do
      page.should have_normal_content("Save this Monster for Later")
    end

    it "shows the new monster" do
      page.should have_normal_content(@mon.name)
    end
  end
end
