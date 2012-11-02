require 'spec_helper'

describe "Web UI" do

  describe "Monster list" do

    before :all do
      Monster.destroy_all
      Monster.new(:name => 'testmonster', :level => 1, :role => 'Artillery').save
      Monster.new(:name => 'a monster', :level => 2, :role => 'Soldier').save
    end

    it "displays Monster attribute headers" do
      visit monsters_path
      page.should have_content "Listing monsters"
      page.should have_content "Name"
      page.should have_content "Level"
      page.should have_content "Role"
      page.should have_content "Subrole"
    end

    it "displays a list of Monsters" do
      visit monsters_path
      page.should have_content "testmonster"
      page.should have_content "Artillery"
      page.should have_content "a monster"
      page.should have_content "Soldier"
    end
  end

  describe "Monster page" do
    it "should display a Monster" do
      Monster.new(:name => 'testmonster', :level => 1, :role => 'Artillery').save
      mon = Monster.find_by_name('testmonster')
      visit monster_path(mon.id)
      page.should have_content "Name"
      page.should have_content "testmonster"
      page.should have_content "Artillery"
    end
  end

end 
