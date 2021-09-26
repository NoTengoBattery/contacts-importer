class CreditCardValidator < ActiveModel::EachValidator
  include CreditCard
  def validate_each(record, attribute, value)
    raise TypeError unless value.is_a?(String) && !value.empty?
    validate_luhn!(value)
    franchise = determine_franchise!(value)
    validate_length!(franchise[:len], value.size)
  rescue ArgumentError, CardLengthError, LuhnError, TypeError
    # Nicely segregated errors to choose an appropiated error message if desired
    record.errors.add(attribute, I18n.t("errors.messages.credit_card")) unless value == "*"
  end

  private

  def validate_luhn!(card)
    digits = card.chars.map { |i| Integer(i, 10) }.reverse
    cksum = 0
    digits.each_slice(2) do |i, j|
      cksum += i
      next unless j
      j *= 2
      j = j.divmod(10).inject(:+) if j > 9
      cksum += j
    end

    raise LuhnError unless cksum.modulo(10).zero?
  end

  def validate_length!(lengths, size)
    lengths.map(&method(:range_normalizer!)).each do |length|
      return true if length.include?(size)
    end
    raise CardLengthError
  end
end
