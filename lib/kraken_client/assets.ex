defmodule KrakenClient.Assets do
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "https://api.kraken.com")
  plug(Tesla.Middleware.JSON)

  defp get_results({:ok, %Tesla.Env{body: %{"result" => result}}}) do
    result
  end

  def get_asset_pairs() do
    get("/0/public/AssetPairs")
    |> get_results
    |> Enum.map(fn {name, pair} -> Map.merge(%{"name" => name}, pair) end)
  end
end
