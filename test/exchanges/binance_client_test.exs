defmodule Exchanges.BinanceClientTest do
  use ExUnit.Case
  alias Exchanges.BinanceClient

  test "status returns online" do
    assert BinanceClient.status() == :online
  end

  test "assets returns available assets" do
    assert BinanceClient.assets() == ["BTC, ETH, DAI"]
  end

  test "assetPairs returns available trading pairs" do
    assert KrakenClient.assetPairs() == [%{}, %{}]
  end
end
