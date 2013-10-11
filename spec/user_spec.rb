require 'spec_helper'

describe User do
  it { should have_many :suggested_talks }

  describe "#password" do
    it { should validate_presence_of(:password) }
  end

  describe "#name" do
    it { should validate_presence_of(:name) }
  end

  describe "#email" do
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:email) }
    it { should allow_value("hello@example.com").for(:email) }
    it { should_not allow_value("helloexample.com").for(:email) }
    it { should_not allow_value("hello@examplecom").for(:email) }
  end

  describe "#suggest_talk" do
    it "Adds the passed in talk to the users talks" do
      user = User.create(random_user_attributes)
      talk = user.suggest_talk(random_talk_attributes)
      expect(user.suggested_talks).to include talk
    end
  end

  describe ".authenticate" do
    let(:user_attributes) { random_user_attributes }
    context "when the user exists" do
      let!(:user) { User.create(user_attributes) }
      it "returns the user" do
        expect(User.authenticate(user_attributes)).to eql(user)
      end

      context "and the password is wrong" do
        it "returns false" do
          user_attributes[:password] = "Wrong password"
          expect(User.authenticate(user_attributes)).to be_false
        end
      end
    end

    context "when the user does not exist" do
      it "returns false" do
        expect(User.authenticate(user_attributes)).to be_false
      end
    end
  end
end
