require 'spec_helper'

describe Monster do
  before do
    @mon = FactoryGirl.create(:monster)
  end

  it { should have_and_belong_to_many(:tags) }
  it { should belong_to(:user) }

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

    it "allows creating a Monster without a user" do
      mon = FactoryGirl.build(:monster)
      mon.user = nil
      mon.save
      mon.should have(0).errors
    end

    it "does not validate a blank name" do
      mon = FactoryGirl.build(:level1_soldier)
      mon.name = ''
      mon.should_not be_valid
    end

    it "does not validate a 0 level" do
      Monster.new(:name => 'testmonster', :level => 0, :role => 'Soldier').should_not be_valid
    end

    it "does not validate a negative level" do
      Monster.new(:name => 'testmonster', :level => -4, :role => 'Soldier').should_not be_valid
    end

    it "does not validate a level over 30" do
      Monster.new(:name => 'testmonster', :level => 31, :role => 'Soldier').should_not be_valid
    end

    it "does validate every level between 1-30" do
      (1 .. 30).each do |lvl|
        Monster.new(:name => 'testmonster'+lvl.to_s, :level => lvl, :role => 'Soldier').should be_valid
      end
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

    context "when it has a duplicate name" do
      context "and a different user" do
        it "does save" do
          user1 = FactoryGirl.create(:user, :email => 'duplicate1@test.com')
          user2 = FactoryGirl.create(:user, :email => 'duplicate2@test.com')
          mon1 = FactoryGirl.create(:level1_soldier, :user => user1)
          mon2 = FactoryGirl.create(:level2_artillery, :user => user2)
          mon1.name = mon2.name
          mon1.save
          mon1.should have(0).errors_on(:name)
        end
      end

      context "and the same user" do
        it "does not save" do
          user = FactoryGirl.create(:user, :email => 'duplicate@test.com')
          mon1 = FactoryGirl.create(:level1_soldier, :user => user)
          mon2 = FactoryGirl.create(:level2_artillery, :user => user)
          mon1.name = mon2.name
          mon1.save
          mon1.should have(1).error_on(:name)
        end
      end
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

    context "and removes its tag" do
      before do
        @tag = FactoryGirl.create(:tag)
        @tag.monsters << @mon1
        @tag.save
      end

      context "when the tag has other monsters" do
        before do
          @mon2 = FactoryGirl.create(:monster, :name => 'removetagmonster')
          @tag.monsters << @mon2
          @tag.save
          @tag.remove_monster(@mon1)
          @tag.save
        end

        it "does not remove the tag" do
          Tag.all.should include(@tag)
        end
      end

      context "when the tag has no other monsters" do
        before do
          @tag.remove_monster(@mon1)
          @tag.save
        end

        it "removes the tag" do
          Tag.all.should_not include(@tag)
        end
      end
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
    
    it "does not remove the owning User" do
      mon = FactoryGirl.create(:monster, :name => 'test owning user')
      user = FactoryGirl.create(:user)
      user.monsters << mon
      mon.destroy
      user.should_not be_nil
    end

    context "when the monster is tagged" do
      context "and there are more monsters with that tag" do
        it "does not remove the tag" do
          user = FactoryGirl.create(:user)
          mon = FactoryGirl.create(:monster, :name => 'test owning tag 1', :user => user)
          mon2 = FactoryGirl.create(:monster, :name => 'test owning tag 2', :user => user)
          tag = FactoryGirl.create(:tag, :user => user)
          tag.monsters << mon << mon2
          tag.save
          mon.destroy
          Tag.all.should include(tag)
        end
      end
      
      context "and there are no other monsters with that tag" do
        it "removes the tag" do
          user = FactoryGirl.create(:user)
          mon = FactoryGirl.create(:monster, :name => 'test owning tag 1', :user => user)
          tag = FactoryGirl.create(:tag, :user => user)
          tag.monsters << mon
          tag.save
          mon.destroy
          Tag.all.should_not include(tag)
        end
      end
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

    it "generates an error for a level 100 monster" do
      lambda { Monster.new(:name => 'testmonster', :level => 100, :role => 'Artillery').xp}.should raise_error(RuntimeError, /valid range for XP/)
    end
  end

  describe "#ability_scores" do
    before :each do
      Monster.destroy_all
      @mon = FactoryGirl.create(:level1_soldier)
    end

    it "returns a hash of six elements" do
      @mon.ability_scores.should have(6).items
    end

    it "each is 13 + (level / 2) for a low stat" do
      @mon.high_ability = :str
      total = 13 + (@mon.level / 2.0).floor
      @mon.ability_scores.each_key do |abil|
        unless abil.to_s == @mon.high_ability.to_s
          @mon.send(abil).should eq total
        end
      end
    end

    it "each is 16 + (level / 2) for a high stat" do
      @mon.high_ability = :dex
      total = 16 + (@mon.level / 2.0).floor
      @mon.send(@mon.high_ability).should eq total
    end

    it "allows setting each score" do
      @mon.ability_scores.each_key do |abil|
        @mon.send("#{abil}=", 5)
        @mon.send(abil).should eq 5
      end
    end

    it "resets the score to the default if set to nil" do
      mon2 = FactoryGirl.build(:level1_soldier)
      mon2.name = mon2.name + '1'
      mon2.int.should_not eq 2
      @mon.int = 2
      @mon.int.should eq 2
      @mon.int = nil
      @mon.int.should eq mon2.int
    end
  end

  describe "#default_score_for" do
    before :each do
      @mon = FactoryGirl.build(:level1_soldier)
    end

    it "returns 13 + (level / 2), which for level 1 = 13" do
      @mon.default_score_for(:str).should eq 13
    end

    it "returns 16 + (level / 2) for a high score, which for level 1 = 16" do
      @mon.high_ability = :str
      @mon.default_score_for(:str).should eq 16
    end

    it "returns 13 + (level / 2), which for level 5 = 15" do
      @mon.level = 5
      @mon.default_score_for(:str).should eq 15
    end

    it "returns 16 + (level / 2) for a high score, which for level 5 = 18" do
      @mon.level = 5
      @mon.high_ability = :str
      @mon.default_score_for(:str).should eq 18
    end
  end

  describe "#hp" do
    context "when the Con score is 10" do
      before :each do
        Monster.destroy_all
        @mon = FactoryGirl.build(:level1_soldier)
        @con_score = 10
        @mon.con = @con_score
      end

      it "returns 8 + (level * 8) + Con score for a Skirmisher" do
        @mon.role = 'Skirmisher'
        @mon.hp.should eq (8 + (@mon.level * 8) + @con_score)
      end

      it "returns 10 + (level * 10) + Con score for a Brute" do
        @mon.role = 'Brute'
        @mon.hp.should eq (10 + (@mon.level * 10) + @con_score)
      end

      it "returns 8 + (level * 8) + Con score for a Soldier" do
        @mon.role = 'Soldier'
        @mon.hp.should eq (8 + (@mon.level * 8) + @con_score)
      end

      it "returns 6 + (level * 6) + Con score for a Lurker" do
        @mon.role = 'Lurker'
        @mon.hp.should eq (6 + (@mon.level * 6) + @con_score)
      end

      it "returns 8 + (level * 8) + Con score for a Controller" do
        @mon.role = 'Controller'
        @mon.hp.should eq (8 + (@mon.level * 8) + @con_score)
      end

      it "returns 6 + (level * 6) + Con score for an Artillery"do
        @mon.role = 'Artillery'
        @mon.hp.should eq (6 + (@mon.level * 6) + @con_score)
      end

      it "returns double HP for an Elite" do
        old_hp = @mon.hp
        @mon.subrole = 'Elite'
        @mon.hp.should eq (old_hp * 2)
      end

      it "returns quadruple the HP for a Solo" do
        old_hp = @mon.hp
        @mon.subrole = 'Solo'
        @mon.hp.should eq (old_hp * 4)
      end
    end
  end

  describe "#starred" do
    before :each do
      Monster.destroy_all
      @mon = FactoryGirl.create(:level1_soldier)
    end

    it "stars the Monster" do
      @mon.starred = true
      @mon.should be_valid
      @mon.save
      @mon.reload
      @mon.starred.should eq true
    end

    it "unstars the Monster" do
      @mon.starred = true
      @mon.save
      @mon.reload
      @mon.starred = false
      @mon.save
      @mon.starred.should eq false
    end
  end

end # Monster
