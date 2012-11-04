require 'spec_helper'

describe "Monster page" do
  context "with a level 1 Artillery Monster" do
    before :all do
      @mon = FactoryGirl.create(:level1_artillery)
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
    before :all do
      @mon = FactoryGirl.create(:level1_elite_artillery)
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

