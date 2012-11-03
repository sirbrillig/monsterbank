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
    context "with a level 1 Artillery Monster" do
      before :all do
        @mon = Monster.new(:name => 'testmonster', :level => 1, :role => 'Artillery')
        @mon.save
      end

      it "displays Monster name, level, and role" do
        visit monster_path(@mon.id)
        page.should have_normal_content "Name: testmonster"
        page.should have_normal_content "Level: 1"
        page.should have_normal_content "Role: Artillery"
      end

      it "displays Monster XP" do
        visit monster_path(@mon.id)
        page.should have_normal_content "XP: 100"
      end
    end

    context "with a level 1 Elite Artillery Monster" do
      before :all do
        @mon = Monster.new(:name => 'testmonster', :level => 1, :role => 'Artillery', :subrole => 'Elite')
        @mon.save
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

  end

end 
