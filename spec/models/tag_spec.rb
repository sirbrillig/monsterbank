require 'spec_helper'

describe Tag do
  before do
    @tag = FactoryGirl.create(:tag)
  end

  it { should validate_presence_of(:name) }
  it { should have_and_belong_to_many(:monsters) }

  describe "#new" do
    before :each do
      Tag.destroy_all
    end

    it "creates a Tag" do
      tag = Tag.new(:name => "my monsters")
    end
  end

  describe "#save an existing Tag" do
    it "allows the Tag to be renamed" do
      Tag.destroy_all
      tag = Tag.new(:name => "my monsters")
      tag.name = 'my monsters two'
      tag.should be_valid
      tag.save
      tag2 = Tag.find_by_name('my monsters two')
      tag2.should_not be_nil
    end

    context "when it has a duplicate name and the same user" do
      it "does not save" do
        user = FactoryGirl.create(:user, :email => 'duplicatetag@test.com')
        tag1 = FactoryGirl.create(:tag, :name => 'duplicatetag1', :user => user)
        tag2 = FactoryGirl.create(:tag, :name => 'duplicatetag2', :user => user)
        tag2.name = tag1.name
        tag2.save
        tag2.should have(1).error_on(:name)
      end
    end
  end

  describe "#save" do
    before :each do
      Tag.destroy_all
    end

    it "saves the Tag" do
      tag1 = Tag.new(:name => "my monsters")
      tag1.save
      tag2 = Tag.find_by_name('my monsters')
      tag2.should_not be_nil
    end

    context "when it has a duplicate name" do
      context "and a different user" do
        it "does save" do
          user1 = FactoryGirl.create(:user, :email => 'duplicatetag1@test.com')
          user2 = FactoryGirl.create(:user, :email => 'duplicatetag2@test.com')
          tag1 = FactoryGirl.create(:tag, :name => 'duplicatetag1', :user => user1)
          tag2 = FactoryGirl.create(:tag, :name => 'duplicatetag2', :user => user2)
          tag1.name = tag2.name
          tag1.save
          tag1.should have(0).errors_on(:name)
        end
      end

      context "and the same user" do
        it "does not save" do
          user = FactoryGirl.create(:user, :email => 'duplicatetag@test.com')
          tag1 = FactoryGirl.create(:tag, :name => 'duplicatetag1', :user => user)
          tag2 = FactoryGirl.build(:tag, :name => 'duplicatetag1', :user => user)
          tag2.save
          tag2.should have(1).error_on(:name)
        end
      end
    end
  end

  describe "#destroy" do
    it "removes the Tag" do
      Tag.destroy_all
      tag1 = Tag.new(:name => 'my monsters')
      tag1.save
      tag1.destroy
      tag2 = Tag.find_by_name('my monsters')
      tag2.should be_nil
    end
  end

end
