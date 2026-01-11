# frozen_string_literal: true

require "rails_helper"

RSpec.describe LocaleController, type: :controller do
  describe "GET #switch" do
    it "switches to Russian locale" do
      get :switch, params: { lang: "ru" }

      expect(session[:locale]).to eq("ru")
      expect(response).to redirect_to(root_path)
    end

    it "switches to English locale" do
      get :switch, params: { lang: "en" }

      expect(session[:locale]).to eq("en")
      expect(response).to redirect_to(root_path)
    end

    it "ignores invalid locales" do
      get :switch, params: { lang: "invalid" }

      expect(session[:locale]).to be_nil
      expect(response).to redirect_to(root_path)
    end

    it "redirects back to referrer if available" do
      request.env["HTTP_REFERER"] = "/lessons"

      get :switch, params: { lang: "ru" }

      expect(response).to redirect_to("/lessons")
    end
  end
end
