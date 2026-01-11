# frozen_string_literal: true

class LocaleController < ApplicationController
  def switch
    locale = params[:lang]

    if I18n.available_locales.include?(locale.to_sym)
      session[:locale] = locale
      I18n.locale = locale.to_sym
    end

    redirect_back(fallback_location: root_path)
  end
end
