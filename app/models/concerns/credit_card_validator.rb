class CreditCardValidator < ActiveModel::EachValidator
  include CreditCard

  def validate_each(record, attribute, value)
    validate_card!(value)
  rescue ArgumentError, CardLengthError, LuhnError, TypeError
    # Nicely segregated errors to choose an appropiated error message if desired
    record.errors.add(attribute, I18n.t("errors.messages.credit_card")) unless value == "*"
  end
end
