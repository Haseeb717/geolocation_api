# frozen_string_literal: true

# spec/models/user_spec.rb

require 'rails_helper'

RSpec.describe User, type: :model do
  subject { described_class.new(email:, password:) }

  let(:email) { 'user@example.com' }
  let(:password) { 'password123' }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without an email' do
      subject.email = nil
      expect(subject).to_not be_valid
      expect(subject.errors[:email]).to include("can't be blank")
    end

    it 'is not valid with a duplicate email' do
      User.create!(email:, password:)
      expect(subject).to_not be_valid
      expect(subject.errors[:email]).to include('has already been taken')
    end

    it 'is not valid without a password on create' do
      subject.password = nil
      expect(subject).not_to be_valid
    end
  end

  describe '#regenerate_api_key' do
    before { subject.save }

    it 'generates a new API key' do
      old_api_key = subject.api_key
      subject.regenerate_api_key
      expect(subject.api_key).to_not eq(old_api_key)
    end
  end

  describe 'callbacks' do
    it 'generates an API key before creating the user' do
      user = User.create!(email:, password:)
      expect(user.api_key).to be_present
    end
  end
end
