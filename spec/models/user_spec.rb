require 'spec_helper'

describe User do
  before do
    @user = FactoryGirl.create(:user)
  end

  it { should have_many(:monsters) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
end
