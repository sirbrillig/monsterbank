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

    it "does not validate an invalid Subrole" do
      Monster.new(:name => 'testmonster', :level => 1, :role => 'Artillery', :subrole => 'Foobar').should_not be_valid
    end

    it "does validate a Solo Subrole" do
      Monster.new(:name => 'testmonster', :level => 1, :role => 'Artillery', :subrole => 'Solo').should be_valid
    end

    it "does validate an Elite Subrole" do
      Monster.new(:name => 'testmonster', :level => 1, :role => 'Artillery', :subrole => 'Elite').should be_valid
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

    context "when it has a valid Subrole" do
      it "saves correctly" do
        Monster.new(:name => 'testmonster', :level => 1, :role => 'Artillery', :subrole => 'Elite').save
        Monster.find_by_name('testmonster').should_not be_nil
      end
    end

    context "when it has an invalid Subrole" do
      it "does not save" do
        Monster.new(:name => 'testmonster', :level => 1, :role => 'Artillery', :subrole => 'Foobar').save
        Monster.find_by_name('testmonster').should eq nil
      end
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

  describe "#xp" do
    it "returns 100 for a level 1 monster" do
      Monster.new(:name => 'testmonster', :level => 1, :role => 'Artillery').xp.should eq 100
    end

    it "returns 300 for a level 7 monster" do
      Monster.new(:name => 'testmonster', :level => 7, :role => 'Artillery').xp.should eq 300
    end

    it "returns 1400 for a level 16 monster" do
      Monster.new(:name => 'testmonster', :level => 16, :role => 'Artillery').xp.should eq 1400
    end

    it "returns 400 for a level 5 elite monster" do
      Monster.new(:name => 'testmonster', :level => 5, :role => 'Artillery', :subrole => 'Elite').xp.should eq 400
    end

    it "returns 44 for a level 4 minion monster" do
      Monster.new(:name => 'testmonster', :level => 4, :role => 'Minion').xp.should eq 44
    end

    it "returns 150 for a level 11 minion monster" do
      Monster.new(:name => 'testmonster', :level => 11, :role => 'Minion').xp.should eq 150
    end

    it "returns 88 for a level 8 minion monster" do
      Monster.new(:name => 'testmonster', :level => 8, :role => 'Minion').xp.should eq 88
    end

    it "returns 3500 for a level 12 solo monster" do
      Monster.new(:name => 'testmonster', :level => 12, :role => 'Artillery', :subrole => 'Solo').xp.should eq 3500
    end

    it "returns 65000 for a level 28 solo monster" do
      Monster.new(:name => 'testmonster', :level => 28, :role => 'Artillery', :subrole => 'Solo').xp.should eq 65000
    end
  end

end # Monster
