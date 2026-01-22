# frozen_string_literal: true

class BaseQuery
  attr_reader :relation

  def initialize(relation = default_relation)
    @relation = relation
  end

  def call
    raise NotImplementedError, "Subclasses must implement #call"
  end

  def self.call(...)
    new(...).call
  end

  private

  def default_relation
    raise NotImplementedError, "Subclasses must implement #default_relation"
  end
end
