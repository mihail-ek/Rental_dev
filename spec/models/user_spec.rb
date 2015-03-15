require 'spec_helper'

describe User do

  it "should require an email address" do
    no_email_user = build :user, email: ""
    no_email_user.should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = build :user, email: address
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = build :user, email: address
      expect(invalid_email_user).not_to be_valid
    end
  end

  it "should reject duplicate email addresses" do
    email = "some_email@gmail.com"
    create :user, email: email
    user_with_duplicate_email = build :user, email: email
    expect(user_with_duplicate_email).not_to be_valid
  end

  it "should reject email addresses identical up to case" do
    email = "lower_case@gmail.com"
    create :user, email: email.upcase
    user_with_duplicate_email = build :user, email: email
    expect(user_with_duplicate_email).not_to be_valid
  end

  describe "password validations" do
    it "should require a password" do
      user = build :user, password: "", password_confirmation: ""
      expect(user).not_to be_valid
    end

    it "should require a matching password confirmation" do
      user = build :user, password_confirmation: "invalid"
      expect(user).not_to be_valid
    end

    it "should reject short passwords" do
      short = "a" * 5
      user = build :user, password: short, password_confirmation: short
      expect(user).not_to be_valid
    end
  end

  describe "password encryption" do
    it "should set the encrypted password attribute" do
      expect(create(:user)).not_to be_blank
    end
  end

  context "#name" do
    it "returns the first name followed by the last name if present" do
      user = build_stubbed :user

      expect(user.name).to eq "#{user.first_name} #{user.last_name}"
    end

    # legacy code workaround
    it "returns the full name if neither the first nor last names are present" do
      name = "User Test"
      user = build_stubbed :user, first_name: "", last_name: "", name: name

      expect(user.name).to eq name
    end
  end
end
