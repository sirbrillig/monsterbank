require 'spec_helper'

describe User do
  before do
    @user = FactoryGirl.create(:user)
  end

  it { should have_many(:monsters) }
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
  end

  describe "#tags" do
    it "lists all the tags" do
      mon1 = FactoryGirl.create(:monster, :name => 'test for tag1')
      mon2 = FactoryGirl.create(:monster, :name => 'test for tag2')
      mon3 = FactoryGirl.create(:monster, :name => 'test for tag3')
      tag1 = FactoryGirl.create(:tag, :name => 'test tag1')
      tag2 = FactoryGirl.create(:tag, :name => 'test tag2')
      tag1.monsters << mon1
      tag2.monsters << mon2 << mon3
      @user.monsters << mon1 << mon2 << mon3
      @user.tags.size.should eq 2
      @user.tags.should include tag1
      @user.tags.should include tag2
    end
  end
end
