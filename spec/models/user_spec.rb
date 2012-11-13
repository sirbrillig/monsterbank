require 'spec_helper'

describe User do
  before do
    @user = FactoryGirl.create(:user)
  end

  it { should have_many(:monsters) }
  it { should have_many(:tags) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }

  describe "#save" do
    it "saves a new User" do
      @user.save
      user2 = User.find_by_email(@user.email)
      user2.should eq @user
    end
  end

  describe "#destroy" do
    it "also destroys owned monsters" do
      mon = FactoryGirl.create(:monster, :name => 'test owned by user')
      @user.monsters << mon
      @user.destroy
      Monster.find_by_name(mon.name).should be_nil
    end

    it "also destroys owned tags" do
      tag = FactoryGirl.create(:tag, :name => 'test tag owned by user')
      @user.tags << tag
      @user.destroy
      Tag.find_by_name(tag.name).should be_nil
    end
  end

  describe "#tags" do
    before do
      mon1 = FactoryGirl.create(:monster, :name => 'test for tag1', :user => @user)
      mon2 = FactoryGirl.create(:monster, :name => 'test for tag2', :user => @user)
      mon3 = FactoryGirl.create(:monster, :name => 'test for tag3', :user => @user)
      @tag1 = FactoryGirl.create(:tag, :name => 'test tag1', :user => @user)
      @tag2 = FactoryGirl.create(:tag, :name => 'test tag2', :user => @user)
      @tag1.monsters << mon1
      @tag2.monsters << mon2 << mon3
      @user.monsters << mon1 << mon2 << mon3
    end
    
    it "includes added tags" do
      @user.tags.should include @tag1
      @user.tags.should include @tag2
    end
  end
end
