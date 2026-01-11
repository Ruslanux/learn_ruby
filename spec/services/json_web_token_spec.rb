require 'rails_helper'

RSpec.describe JsonWebToken do
  describe ".encode" do
    it "encodes a payload into a JWT token" do
      token = described_class.encode(user_id: 1)
      expect(token).to be_a(String)
      expect(token.split(".").length).to eq(3)
    end

    it "sets default expiration to 24 hours" do
      token = described_class.encode(user_id: 1)
      decoded = described_class.decode(token)

      expect(decoded[:exp]).to be_within(60).of(24.hours.from_now.to_i)
    end

    it "allows custom expiration" do
      token = described_class.encode({ user_id: 1 }, 1.hour.from_now)
      decoded = described_class.decode(token)

      expect(decoded[:exp]).to be_within(60).of(1.hour.from_now.to_i)
    end
  end

  describe ".decode" do
    it "decodes a valid token" do
      token = described_class.encode(user_id: 123, foo: "bar")
      decoded = described_class.decode(token)

      expect(decoded[:user_id]).to eq(123)
      expect(decoded[:foo]).to eq("bar")
    end

    it "raises error for expired token" do
      token = described_class.encode({ user_id: 1 }, 1.second.ago)

      expect {
        described_class.decode(token)
      }.to raise_error(JWT::ExpiredSignature)
    end

    it "raises error for invalid token" do
      expect {
        described_class.decode("invalid.token.here")
      }.to raise_error(JWT::DecodeError)
    end
  end
end
