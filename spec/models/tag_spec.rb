require 'spec_helper'

describe Tag do
  before do
    @tag = FactoryGirl.create(:tag)
  end

  it { should validate_uniqueness_of(:name) }
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
