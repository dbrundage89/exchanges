defmodule KrakenClient do
  @moduledoc """
  Documentation for `KrakenClient`.
  """
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "https://api.kraken.com")
  plug(Tesla.Middleware.JSON)

  @assets[AssetPair]

  @doc """
  Get exchange status

  ## Examples

      iex> KrakenClient.status()
      :online

  """
  def status do
    {:ok, %Tesla.Env{body: %{"result" => %{"status" => status, "timestamp" => timestamp}}}} =
      get("/0/public/SystemStatus")

    case(status) do
      "online" -> :online
      _ -> {:error, "Kraken returned unknown status: #{status} at #{timestamp} "}
    end
  end

  def assets do
    {:ok, %Tesla.Env{body: %{"result" => result}}} = get("/0/public/Assets")
    Map.keys(result)
  end
end
