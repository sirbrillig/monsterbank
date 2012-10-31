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

  describe "Monster page" do
    it "should display a Monster" do
      # FIXME: need to create one first.
    end
  end
end # Monster view
