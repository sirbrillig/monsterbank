require 'spec_helper'

describe "Monster view" do

  describe "Monster list" do
    it "should display a list of Monsters" do
      visit monsters_path
      page.should have_content "monsters"
      page.should have_content "Name"
      page.should have_content "Level"
      page.should have_content "Role"
      page.should have_content "Subrole"
    end
  end

  # FIXME: this is a unit test
  describe "Creating a Monster" do
    it "should make a Monster" do
      mon1 = Monster.new(:name => 'testmonster', :level => 1, :role => 'Artillery')
      mon1.save
      mon2 = Monster.find_by_name('testmonster')
      mon2.should eq mon1
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
end # Monster view
