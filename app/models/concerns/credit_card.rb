module CreditCard
  def determine_franchise!(card)
    CREDIT_CARD_STRUCTURE.each do |franchise|
      franchise[:iin].map(&method(:range_normalizer!)).each do |iin|
        iin_size = Integer(Math.log10(iin.first)) + 1
        card_iin = Integer(card[0...iin_size])
        return franchise if iin.include?(card_iin)
      end
    end
    raise FranchiseError
  end

  protected

  def range_normalizer!(suspect)
    return suspect if suspect.is_a?(Range)
    suspect = Integer(suspect)
    Range.new(suspect, suspect)
  end
end
