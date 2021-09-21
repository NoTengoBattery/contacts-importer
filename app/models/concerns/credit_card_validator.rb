class CreditCardValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    raise TypeError unless value.is_a? String
    determine_franchise(value)
  rescue TypeError
    record.errors.add(attribute, I18n.t("errors.messages.credit_card"))
  end

  private

  CARD_DATA = [
    {name: "American Express", inn: [34, 37], len: [15]},
    {name: "Bankcard", inn: [5610, 560221..560225], len: [16]},
    {name: "China T-Union", inn: [31], len: [19]},
    {name: "China UnionPay", inn: [62], len: [16..19]},
    {name: "Dankort", inn: [5019, 4571], len: [16]},
    {name: "Diners Club International", inn: [36], len: [14..19]},
    {name: "Diners Club United States & Canada", inn: [54], len: [16]},
    {name: "Discover Card", inn: [6011, 622126..622925, 644..649, 65], len: [16..19]},
    {name: "InstaPayment", inn: [637..639], len: [16]},
    {name: "InterPayment", inn: [636], len: [16..19]},
    {name: "JCB", inn: [3528..3589], len: [16..19]},
    # {name: "LankaPay", inn: [357111], len: [16]},
    # {name: "Laser", inn: [6304, 6706, 6771, 6709], len: [16..19]},
    {name: "Maestro", inn: [5018, 5020, 5038, 5893, 6304, 6759, 6761, 6762, 6763], len: [12..19]},
    {name: "Maestro UK", inn: [6759, 676770, 676774], len: [12..19]},
    {name: "Mastercard", inn: [2221..2720, 51..55], len: [16]},
    {name: "Mir", inn: [2200..2204], len: [16..19]},
    {name: "NPS Pridnestrovie", inn: [6054740..6054744], len: [16]},
    {name: "RuPay", inn: [60, 652, 81, 82, 508, 3538, 3561], len: [16]},
    # {name: "Solo", inn: [6334, 6767], len: [16, 18, 19]},
    # {name: "Switch", inn: [4903, 4905, 4911, 4936, 564182, 633110, 6333, 6759], len: [16, 18, 19]},
    {name: "Troy", inn: [65, 9792], len: [16]},
    # {name: "UATP", inn: [1], len: [15]},
    {name: "UkrCard", inn: [60400100..60420099], len: [16..19]},
    # {name: "Verve", inn: [506099..506198, 650002..650027], len: []},
    {name: "Visa", inn: [4], len: [13, 16]},
    {name: "Visa Electron", inn: [4026, 417500, 4508, 4844, 4913, 4917], len: [16]}
  ]

  def determine_franchise(card)
  end
end
