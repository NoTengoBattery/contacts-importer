class Iso8601Validator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    raise TypeError unless value.is_a? String
    Date.iso8601(value)
  rescue Date::Error, TypeError
    record.errors.add(attribute, I18n.t("errors.messages.iso8601"))
  end
end
