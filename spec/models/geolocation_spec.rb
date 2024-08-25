# frozen_string_literal: true

# spec/models/geolocation_spec.rb

require 'rails_helper'

RSpec.describe Geolocation, type: :model do
  subject do
    described_class.new(ip_address:, latitude:, longitude:, city:, country:)
  end

  let(:ip_address) { '192.168.1.1' }
  let(:latitude) { 37.7749 }
  let(:longitude) { -122.4194 }
  let(:city) { 'San Francisco' }
  let(:country) { 'USA' }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without an ip_address' do
      subject.ip_address = nil
      expect(subject).to_not be_valid
      expect(subject.errors[:ip_address]).to include("can't be blank")
    end

    it 'is not valid with a duplicate ip_address' do
      Geolocation.create!(ip_address:, latitude:, longitude:, city:, country:)
      expect(subject).to_not be_valid
      expect(subject.errors[:ip_address]).to include('has already been taken')
    end

    it 'is not valid with an invalid ip_address format' do
      subject.ip_address = 'invalid_ip'
      expect(subject).to_not be_valid
      expect(subject.errors[:ip_address]).to include('must be a valid IPv4 address')
    end

    it 'is not valid without latitude' do
      subject.latitude = nil
      expect(subject).to_not be_valid
      expect(subject.errors[:latitude]).to include("can't be blank")
    end

    it 'is not valid without longitude' do
      subject.longitude = nil
      expect(subject).to_not be_valid
      expect(subject.errors[:longitude]).to include("can't be blank")
    end

    it 'is not valid without city' do
      subject.city = nil
      expect(subject).to_not be_valid
      expect(subject.errors[:city]).to include("can't be blank")
    end

    it 'is not valid without country' do
      subject.country = nil
      expect(subject).to_not be_valid
      expect(subject.errors[:country]).to include("can't be blank")
    end

    it 'is not valid with latitude less than -90' do
      subject.latitude = -91
      expect(subject).to_not be_valid
      expect(subject.errors[:latitude]).to include('must be greater than or equal to -90')
    end

    it 'is not valid with latitude greater than 90' do
      subject.latitude = 91
      expect(subject).to_not be_valid
      expect(subject.errors[:latitude]).to include('must be less than or equal to 90')
    end

    it 'is not valid with longitude less than -180' do
      subject.longitude = -181
      expect(subject).to_not be_valid
      expect(subject.errors[:longitude]).to include('must be greater than or equal to -180')
    end

    it 'is not valid with longitude greater than 180' do
      subject.longitude = 181
      expect(subject).to_not be_valid
      expect(subject.errors[:longitude]).to include('must be less than or equal to 180')
    end
  end
end
