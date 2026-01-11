# frozen_string_literal: true

class ErrorsController < ApplicationController
  skip_before_action :set_locale, only: [ :not_found, :internal_error, :unprocessable ]

  def not_found
    respond_to do |format|
      format.html { render status: :not_found }
      format.json { render json: { error: "Not found" }, status: :not_found }
    end
  end

  def internal_error
    respond_to do |format|
      format.html { render status: :internal_server_error }
      format.json { render json: { error: "Internal server error" }, status: :internal_server_error }
    end
  end

  def unprocessable
    respond_to do |format|
      format.html { render status: :unprocessable_entity }
      format.json { render json: { error: "Unprocessable entity" }, status: :unprocessable_entity }
    end
  end
end
