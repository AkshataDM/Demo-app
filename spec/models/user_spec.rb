require 'spec_helper'

describe User do


  before { @user = User.new(name: "Example User", email: "user@example.com",password: "foobar", password_confirmation: "foobar") }

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should be_valid }
   it { should respond_to(:password_digest) }
it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
    it { should respond_to(:remember_token) }
 it { should respond_to(:authenticate) }
it { should be_valid }

describe "when password is not present" do
  before do
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: " ", password_confirmation: " ")
  end
  it { should_not be_valid }
end

describe "when password doesn't match confirmation" do
  before { @user.password_confirmation = "mismatch" }
  it { should_not be_valid }
end

  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

 describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end
describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end

describe "signup" do

 before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end
  end

describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end
end
