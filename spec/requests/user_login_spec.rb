require 'spec_helper'

describe "User Log In" do
  it "allows a user to sign up" do
    visit signup_path
    fill_in('user[email]', :with => 'test@test.com') 
    fill_in('user[password]', :with => 'foobar')
    fill_in('user[password_confirmation]', :with => 'foobar')
    click_button('Sign Up')

    page.should have_content "You are signed-up"
  end

  it "allows an existing user to log in" do
    @user = FactoryGirl.create(:user)
    visit login_path
    fill_in('email', :with => @user.email) 
    fill_in('password', :with => @user.password)
    click_button('Log In')

    page.should have_content "You are now logged in"
  end

  context "when arriving as a user with no password" do
    it "displays a sign-up form for the password"
  end
end
