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
end
