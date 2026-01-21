class ApplicationSerializer
  attr_reader :object, :options

  def initialize(object, options = {})
    @object = object
    @options = options
  end

  def as_json
    raise NotImplementedError, "Subclasses must implement #as_json"
  end

  def to_json(*_args)
    as_json.to_json
  end

  def self.serialize(object, options = {})
    new(object, options).as_json
  end

  def self.serialize_collection(collection, options = {})
    collection.map { |item| new(item, options).as_json }
  end

  private

  def current_user
    options[:current_user]
  end
end
