defmodule KrakenClientTest do
  use ExUnit.Case
  doctest KrakenClient

  test "greets the world" do
    assert KrakenClient.hello() == :world
  end
end
