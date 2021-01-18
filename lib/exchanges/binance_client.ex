defmodule Exchanges.BinanceClient do
  @moduledoc """
  Documentation for `Exchanges.BinanceClient`.
  """
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "https://api.binance.us")
  plug(Tesla.Middleware.JSON)

  defp get_body({:ok, %Tesla.Env{body: body}}) do
    body
  end

  def status do
    {:ok, %Tesla.Env{status: status}} = get("/api/v3/ping")

    case status do
      200 -> :online
      _ -> {:error, "Binance returned status: #{status}"}
    end
  end

  def assets do
  end

  defp assetPair_filterItem(assetPair, filterType, itemName) do
    assetPair["filters"]
    |> Enum.filter(fn item -> item["filterType"] == filterType end)
    |> Enum.at(0)
    |> (&with({number, _} <- Float.parse(&1[itemName]), do: number)).()
  end

  def assetPairs do
    get("/api/v3/exchangeInfo")
    |> get_body()
    |> (fn %{"symbols" => symbols} -> symbols end).()
    |> Enum.map(fn assetPair ->
      %{
        name: assetPair["symbol"],
        base: assetPair["baseAsset"],
        quote: assetPair["quoteAsset"],
        ordermin: assetPair_filterItem(assetPair, "LOT_SIZE", "minQty"),
        price_stepSize: assetPair_filterItem(assetPair, "PRICE_FILTER", "tickSize"),
        lot_stepSize: assetPair_filterItem(assetPair, "LOT_SIZE", "stepSize")
      }
    end)
  end
end
