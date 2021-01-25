defmodule Exchanges.Resource.AssetPair do
  defstruct symbol: nil,
            base: nil,
            quote: nil,
            ordermin: nil,
            price_stepsize: nil,
            lot_stepsize: nil

  defp get_filter_item(filters, filter_type, item_name) do
    filters
    |> Enum.filter(fn item -> item[:filterType] == filter_type end)
    |> Enum.at(0)
    |> (&with({number, _} <- Float.parse(&1[item_name]), do: number)).()
  end

  def from_binance(asset_pair) do
    %Exchanges.Resource.AssetPair{
      symbol: asset_pair[:symbol],
      base: asset_pair[:baseAsset],
      quote: asset_pair[:quoteAsset],
      ordermin: asset_pair.filters |> get_filter_item("LOT_SIZE", :minQty),
      price_stepsize: asset_pair.filters |> get_filter_item("PRICE_FILTER", :tickSize),
      lot_stepsize: asset_pair.filters |> get_filter_item("LOT_SIZE", :stepSize)
    }
  end
end
