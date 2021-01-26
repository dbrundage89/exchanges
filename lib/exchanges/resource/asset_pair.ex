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

  def from_kraken(asset_pair) do
    %Exchanges.Resource.AssetPair{
      symbol: asset_pair[:symbol],
      base: asset_pair[:base],
      quote: asset_pair[:quote],
      ordermin: with({number, _} <- Float.parse(asset_pair[:ordermin]), do: number),
      price_stepsize: :math.pow(10, -1 * asset_pair[:pair_decimals]),
      lot_stepsize: :math.pow(10, -1 * asset_pair[:lot_decimals])
    }
  end
end
