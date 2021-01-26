defmodule Exchanges.KrakenClient do
  @moduledoc """
  Documentation for `Exchanges.KrakenClient`.
  """
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "https://api.kraken.com")
  plug(Tesla.Middleware.JSON, engine_opts: [keys: :atoms])

  alias Exchanges.Resource

  defp get_results({:ok, %Tesla.Env{body: %{result: result}}}) do
    result
  end

  def get_url(url) do
    get(url)
  end

  def status do
    {:ok, %Tesla.Env{body: %{result: %{status: status, timestamp: timestamp}}}} =
      get("/0/public/SystemStatus")

    case(status) do
      "online" -> :online
      _ -> {:error, "Kraken returned unknown internal status: #{status} at #{timestamp} "}
    end
  end

  def assets do
    get("/0/public/Assets")
    |> get_results
    |> Map.keys()
    |> Enum.map(fn asset -> Atom.to_string(asset) end)
  end

  def asset_pairs() do
    get("/0/public/AssetPairs")
    |> get_results
    |> Enum.map(fn {symbol, pair} -> Map.merge(%{symbol: symbol}, pair) end)
    |> Enum.map(fn asset_pair ->
      Resource.AssetPair.from_kraken(asset_pair)
    end)
  end
end
