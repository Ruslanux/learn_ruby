# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Error Pages", type: :request do
  describe "GET /404" do
    it "renders 404 page content" do
      get "/404"

      expect(response.body).to include("404")
      expect(response.body).to include("Page not found")
    end
  end

  describe "GET /500" do
    it "renders 500 page content" do
      get "/500"

      expect(response.body).to include("500")
      expect(response.body).to include("Something went wrong")
    end
  end

  describe "GET /422" do
    it "renders 422 page content" do
      get "/422"

      expect(response.body).to include("422")
      expect(response.body).to include("Forbidden")
    end
  end

  describe "JSON responses" do
    it "returns JSON for 404" do
      get "/404", headers: { "Accept" => "application/json" }

      expect(response.content_type).to include("application/json")
      expect(JSON.parse(response.body)).to eq("error" => "Not found")
    end

    it "returns JSON for 500" do
      get "/500", headers: { "Accept" => "application/json" }

      expect(response.content_type).to include("application/json")
      expect(JSON.parse(response.body)).to eq("error" => "Internal server error")
    end

    it "returns JSON for 422" do
      get "/422", headers: { "Accept" => "application/json" }

      expect(response.content_type).to include("application/json")
      expect(JSON.parse(response.body)).to eq("error" => "Unprocessable entity")
    end
  end
end
