class CreditCardValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    raise TypeError unless value.is_a?(String) && !value.empty?
    validate_luhn(value)
    franchise = determine_franchise(value)
    validate_length(franchise[:len], value.size)
  rescue ArgumentError, CardLengthError, LuhnError, TypeError
    # Nicely segregated errors to choose an appropiated error message if desired
    record.errors.add(attribute, I18n.t("errors.messages.credit_card"))
  end

  private

  CARD_DATA = [
    {name: "American Express", iin: [34, 37], len: [15]},
    {name: "Bankcard", iin: [5610, 560221..560225], len: [16]},
    {name: "China T-Union", iin: [31], len: [19]},
    {name: "China UnionPay", iin: [62], len: [16..19]},
    {name: "Dankort", iin: [5019, 4571], len: [16]},
    {name: "Diners Club International", iin: [36], len: [14..19]},
    {name: "Diners Club United States & Canada", iin: [54], len: [16]},
    {name: "Discover Card", iin: [6011, 622126..622925, 644..649, 65], len: [16..19]},
    {name: "InstaPayment", iin: [637..639], len: [16]},
    {name: "InterPayment", iin: [636], len: [16..19]},
    {name: "JCB", iin: [3528..3589], len: [16..19]},
    # {name: "LankaPay", iin: [357111], len: [16]},
    # {name: "Laser", iin: [6304, 6706, 6771, 6709], len: [16..19]},
    {name: "Maestro", iin: [5018, 5020, 5038, 5893, 6304, 6759, 6761, 6762, 6763], len: [12..19]},
    {name: "Maestro UK", iin: [6759, 676770, 676774], len: [12..19]},
    {name: "Mastercard", iin: [2221..2720, 51..55], len: [16]},
    {name: "Mir", iin: [2200..2204], len: [16..19]},
    {name: "NPS Pridnestrovie", iin: [6054740..6054744], len: [16]},
    {name: "RuPay", iin: [60, 652, 81, 82, 508, 3538, 3561], len: [16]},
    # {name: "Solo", iin: [6334, 6767], len: [16, 18, 19]},
    # {name: "Switch", iin: [4903, 4905, 4911, 4936, 564182, 633110, 6333, 6759], len: [16, 18, 19]},
    {name: "Troy", iin: [65, 9792], len: [16]},
    # {name: "UATP", iin: [1], len: [15]},
    {name: "UkrCard", iin: [60400100..60420099], len: [16..19]},
    # {name: "Verve", iin: [506099..506198, 650002..650027], len: []},
    {name: "Visa", iin: [4], len: [13, 16]},
    {name: "Visa Electron", iin: [4026, 417500, 4508, 4844, 4913, 4917], len: [16]}
  ]

  def validate_luhn(card)
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

  def range_normalizer(suspect)
    return suspect if suspect.is_a?(Range)
    suspect = Integer(suspect)
    Range.new(suspect, suspect)
  rescue TypeError
    nil
  end

  def determine_franchise(card)
    CARD_DATA.each do |franchise|
      franchise[:iin].map(&method(:range_normalizer)).each do |iin|
        iin_size = Integer(Math.log10(iin.first)) + 1
        card_iin = Integer(card[0...iin_size])
        return franchise if iin.include?(card_iin)
      end
    end
    raise FranchiseError
  end

  def validate_length(lengths, size)
    lengths.map(&method(:range_normalizer)).each do |length|
      return true if length.include?(size)
    end
    raise CardLengthError
  end
end
