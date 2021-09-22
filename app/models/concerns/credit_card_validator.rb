class CreditCardValidator < ActiveModel::EachValidator
  include CreditCard

  def validate_each(record, attribute, value)
    raise TypeError unless value.is_a?(String) && !value.empty?
    return true if value == "*"
    validate_luhn(value)
    franchise = determine_franchise(value)
    validate_length(franchise[:len], value.size)
  rescue ArgumentError, CardLengthError, LuhnError, TypeError
    # Nicely segregated errors to choose an appropiated error message if desired
    record.errors.add(attribute, I18n.t("errors.messages.credit_card"))
  end
end
