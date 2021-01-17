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

  def assetPairs do
    get("/api/v3/exchangeInfo")
    |> get_body()
    |> (fn %{"symbols" => symbols} -> symbols end).()
    |> Enum.map(fn asset ->
      %{
        name: asset["symbol"],
        base: asset["baseAsset"],
        quote: asset["quoteAsset"],
        ordermin:
          asset["filters"]
          |> Enum.filter(fn item -> item["filterType"] == "LOT_SIZE" end)
          |> Enum.at(0)
          |> (&with({number, _} <- Float.parse(&1["minQty"]), do: number)).(),
        price_stepSize:
          asset["filters"]
          |> Enum.filter(fn item -> item["filterType"] == "PRICE_FILTER" end)
          |> Enum.at(0)
          |> (&with({number, _} <- Float.parse(&1["tickSize"]), do: number)).(),
        lot_stepSize:
          asset["filters"]
          |> Enum.filter(fn item -> item["filterType"] == "LOT_SIZE" end)
          |> Enum.at(0)
          |> (&with({number, _} <- Float.parse(&1["stepSize"]), do: number)).()
      }
    end)
  end
end
