defmodule KrakenClientTest do
  use ExUnit.Case
  doctest KrakenClient

  test "status returns online" do
    assert KrakenClient.status() == :online
  end
end
