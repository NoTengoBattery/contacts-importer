module CreditCard
  def validate_card!(card)
    raise TypeError unless card.is_a?(String) && !card.empty?
    validate_luhn(card)
    franchise = determine_franchise(card)
    validate_length(franchise[:len], card.size)
    {franchise: franchise, length: card.size}
  end

  def valid_card?(card)
    validate_card!(card)
  rescue
    false
  end

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

  def determine_franchise(card)
    CREDIT_CARD_STRUCTURE.each do |franchise|
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

  private

  def range_normalizer(suspect)
    return suspect if suspect.is_a?(Range)
    suspect = Integer(suspect)
    Range.new(suspect, suspect)
  rescue TypeError
    nil
  end
end
