require 'spec_helper'

describe "Monster page" do
  context "when not logged-in" do
    before do
      @mon = FactoryGirl.create(:monster, :name => 'notloggedin monster')
    end

    context "and the monster is owned by a user" do
      before do
        @user = FactoryGirl.create(:user, :email => 'owninguser@test.com')
        @mon.user = @user
        @mon.save
        visit monster_path(@mon)
      end

      it "displays no email field" do
        page.should_not have_field('user[email]')
      end

      it "displays no link to a monster list" do
        page.should_not have_link_to(monsters_path)
      end

      it "displays no link to an edit page" do
        page.should_not have_link_to(edit_monster_path(@mon))
      end
    end

    context "and the monster is not owned by a user" do
      before do
        @mon.user = nil
        @mon.save
        @user = FactoryGirl.build(:user, :email => 'notowninguser@test.com')
        visit monster_path(@mon)
      end

      it "displays a 'save this monster' form with an email field" do
        page.should have_field('user[email]')
        page.should have_button('Save')
      end

      context "and an existing email address is entered" do
        before do
          @user2 = FactoryGirl.create(:user, :email => 'notappearinginthisfilm@test.com')
          fill_in('user[email]', :with => @user2.email)
          click_button('Save')
        end

        it "says that this account exists" do
          page.should have_content "exists"
        end

        it "does not show a sign-up form" do
          page.should_not have_field('user[password_confirmation]')
        end

        it "requests a password" do
          page.should have_field('user[password]')
        end

        it "then redirects to the monster list page" do
          fill_in('user[password]', :with => @user2.password)
          click_button('Save')
          page.should have_content "All Monsters"
        end
      end

      context "and a new email address is entered" do
        before do
          fill_in('user[email]', :with => @user.email)
          click_button('Save')
        end

        it "brings the user to a sign-up form" do
          page.should have_field('user[password_confirmation]')
        end

        context "and the sign-up form is filled" do
          before do
            fill_in('user[password]', :with => @user.password)
            fill_in('user[password_confirmation]', :with => @user.password)
            click_button('Save')
          end

          it "logs-in the user" do
            page.should have_link_to(logout_path)
          end

          it "returns the user to the monster list" do
            page.should have_normal_content "All Monsters"
          end
        end
      end
    end
  end

  context "when logged-in" do
    before do
      @user = FactoryGirl.create(:user)
      visit login_path
      fill_in('email', :with => @user.email) 
      fill_in('password', :with => @user.password)
      click_button('Log In')
    end


    context "with a level 1 Artillery Monster" do
      before do
        @mon = FactoryGirl.create(:level1_artillery, :user => @user)
      end

      it "displays Monster name, level, and role" do
        visit monster_path(@mon)
        page.should have_normal_content "#{@mon.name}"
        page.should have_normal_content "#{@mon.level}"
        page.should have_normal_content "#{@mon.role}"
      end

      it "displays Monster XP" do
        visit monster_path(@mon)
        page.should have_normal_content "XP 100"
      end
    end

    context "with a level 1 Elite Artillery Monster" do
      before do
        @mon = FactoryGirl.create(:level1_elite_artillery, :user => @user)
      end

      it "displays Elite subrole" do
        visit monster_path(@mon)
        page.should have_normal_content 'Elite Artillery'
      end

      it "displays double XP for a Elite" do
        visit monster_path(@mon)
        page.should have_normal_content 'XP 200'
      end
    end
  end
end
