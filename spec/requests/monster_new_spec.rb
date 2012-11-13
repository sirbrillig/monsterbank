require 'spec_helper'

describe "The New Monster page" do
  it "displays the form for creating a monster" do
    visit new_monster_path
    page.should have_field('monster[name]')
    page.should have_field('monster[level]')
    page.should have_field('monster[role]')
    page.should have_field('monster[subrole]')
    page.should have_button('Save')
  end
end
