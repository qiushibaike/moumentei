# coding: utf-8
class JSONColumn
  RESCUE_ERRORS = [ ActiveSupport::JSON.backend::ParseError ]

  attr_accessor :object_class

  def initialize(object_class = Object)
    @object_class = object_class
  end

  def dump(obj)
    ActiveSupport::JSON.encode obj
  end

  def load(json)
    return object_class.new if object_class != Object && json.blank?
    return json unless json.is_a?(String)

    begin
      obj = ActiveSupport::JSON.decode(json)
      obj.nested_under_indifferent_access! if obj.is_a?(Hash)

      unless obj.is_a?(object_class) || obj.nil?
        raise SerializationTypeMismatch,
          "Attribute was supposed to be a #{object_class}, but was a #{obj.class}"
      end
      obj ||= object_class.new if object_class != Object

      obj
    rescue *RESCUE_ERRORS
      json
    end
  end
end
