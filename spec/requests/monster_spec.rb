require 'spec_helper'

describe Monster do

  describe "#new" do
    before :each do
      Monster.destroy_all
    end

    it "creates a Monster" do
      mon1 = Monster.new(:name => 'testmonster', :level => 1, :role => 'Artillery')
      mon1.name.should eq 'testmonster'
      mon1.level.should eq 1
      mon1.role.should eq 'Artillery'
    end

    it "does not validate an invalid Role" do
      Monster.new(:name => 'testmonster', :level => 1, :role => 'Foobar').should_not be_valid
    end

    it "does not validate a negative level" do
      Monster.new(:name => 'testmonster', :level => -1, :role => 'Artillery').should_not be_valid
    end
  end

  describe "#save" do
    before :each do
      Monster.destroy_all
    end

    it "saves a Monster" do
      mon1 = Monster.new(:name => 'testmonster', :level => 1, :role => 'Artillery')
      mon1.save
      mon2 = Monster.find_by_name('testmonster')
      mon2.should_not be_nil 
    end

    context "when it has an invalid Role" do
      it "does not save" do
        Monster.new(:name => 'testmonster', :level => 1, :role => 'Foobar').save
        Monster.find_by_name('testmonster').should eq nil
      end

    end
  end

  describe "#save an existing Monster" do
    before :each do
      Monster.destroy_all
      @mon1 = Monster.new(:name => 'testmonster', :level => 1, :role => 'Artillery')
      @mon1.save
      @mon1.reload
      @mon1.name = 'testmonster2'
      @mon1.level = 2
      @mon1.role = 'Soldier'
      @mon1.save
      @mon1.reload
      @mon2 = Monster.find_by_name('testmonster2')
    end

    it "updates the name" do
      @mon1.name.should eq 'testmonster2'
      @mon2.name.should eq @mon1.name
    end

    it "updates the level" do
      @mon1.level.should eq 2
      @mon2.level.should eq @mon1.level
    end

    it "updates the role" do
      @mon1.role.should eq 'Soldier'
      @mon2.role.should eq @mon1.role
    end
  end

  describe "#destroy" do
    it "removes the Monster" do
      Monster.destroy_all
      mon1 = Monster.new(:name => 'testmonster', :level => 1, :role => 'Artillery')
      mon1.save
      mon1.destroy
      mon2 = Monster.find_by_name('testmonster')
      mon2.should be_nil
    end
  end

end # Monster
