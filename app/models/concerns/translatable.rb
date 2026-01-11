# frozen_string_literal: true

module Translatable
  extend ActiveSupport::Concern

  class_methods do
    def translates(*attributes)
      attributes.each do |attr|
        define_method("translated_#{attr}") do
          if I18n.locale == :ru
            ru_value = send("#{attr}_ru")
            ru_value.present? ? ru_value : send(attr)
          else
            send(attr)
          end
        end
      end
    end
  end
end
