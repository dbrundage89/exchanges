defmodule Exchanges.BinanceClient do
  @moduledoc """
  Documentation for `Exchanges.BinanceClient`.
  """
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "https://api.binance.us")
  plug(Tesla.Middleware.JSON, engine_opts: [keys: :atoms])

  alias Exchanges.Resource

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
    get("/api/v3/exchangeInfo")
    |> get_body()
    |> (& &1[:symbols]).()
    |> Enum.reduce([], fn assetPair, acc ->
      acc ++ [assetPair[:quoteAsset], assetPair[:baseAsset]]
    end)
    |> Enum.uniq()
  end

  def asset_pairs do
    get("/api/v3/exchangeInfo")
    |> get_body()
    |> (& &1[:symbols]).()
    |> Enum.map(fn asset_pair -> Resource.AssetPair.from_binance(asset_pair) end)
  end

  def prices do
    get("/api/v3/ticker/price")
    |> get_body()
    |> Enum.map(fn price -> Resource.Price.from_binance(price) end)
  end
end
