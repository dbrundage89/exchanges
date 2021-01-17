defmodule Exchanges.KrakenClient do
  @moduledoc """
  Documentation for `Exchanges.KrakenClient`.
  """
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "https://api.kraken.com")
  plug(Tesla.Middleware.JSON)

  defp get_results({:ok, %Tesla.Env{body: %{"result" => result}}}) do
    result
  end

  def status do
    {:ok, %Tesla.Env{body: %{"result" => %{"status" => status, "timestamp" => timestamp}}}} =
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
  end

  def assetPairs() do
    get("/0/public/AssetPairs")
    |> get_results
    |> Enum.map(fn {name, pair} -> Map.merge(%{"name" => name}, pair) end)
    |> Enum.map(fn asset ->
      %{
        name: asset["name"],
        base: asset["base"],
        quote: asset["quote"],
        ordermin: with({number, _} <- Float.parse(asset["ordermin"]), do: number),
        price_stepSize: :math.pow(10, -1 * asset["pair_decimals"]),
        lot_stepSize: :math.pow(10, -1 * asset["lot_decimals"])
      }
    end)
  end
end
