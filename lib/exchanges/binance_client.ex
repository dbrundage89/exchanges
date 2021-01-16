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
    get("/api/v3/exchangeInfo")
    |> get_body()
  end

  def assets do
  end

  def assetPairs do
  end
end
