defmodule KrakenClient.Assets.Pair do
  # things I care about defstruct [:name, :base, :quote, :fees, :price_stepSize, :lot_stepSize]
  defstruct [
    :name,
    :aclass_base,
    :aclass_quote,
    :altname,
    :base,
    :fee_volume_currency,
    :fees,
    :fees_maker,
    :leverage_buy,
    :leverage_sell,
    :lot,
    :lot_decimals,
    :lot_multiplier,
    :margin_call,
    :margin_stop,
    :ordermin,
    :pair_decimals,
    :quote,
    :wsname
  ]
end
