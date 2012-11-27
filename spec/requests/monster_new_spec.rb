require 'spec_helper'

describe "The New Monster page" do
  it "displays the form for creating a monster" do
    visit new_monster_path
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

    it "shows an email address field"

    context "when entering a email address that exists" do
      it "says that this account exists"

      it "requests a password"

      it "then redirects to the monster list page"
    end

    context "when entering a new email address" do
      it "requests a password"

      it "then redirects to the monster list page"
    end
  end
end
