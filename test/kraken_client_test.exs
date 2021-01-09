defmodule KrakenClientTest do
  use ExUnit.Case
  doctest KrakenClient

  setup do
    Tesla.Mock.mock(fn env ->
      case env.url do
        "https://api.kraken.com/0/public/SystemStatus" ->
          %Tesla.Env{
            body: %{
              "error" => [],
              "result" => %{"status" => "online", "timestamp" => "2021-01-08T22:41:56Z"}
            }
          }

        "https://api.kraken.com/0/public/Assets" ->
          %Tesla.Env{
            body: %{
              "error" => [],
              "result" => %{
                "REPV2" => %{
                  "aclass" => "currency",
                  "altname" => "REPV2",
                  "decimals" => 10,
                  "display_decimals" => 5
                },
                "KAVA.S" => %{
                  "aclass" => "currency",
                  "altname" => "KAVA.S",
                  "decimals" => 8,
                  "display_decimals" => 6
                },
                "EUR.HOLD" => %{
                  "aclass" => "currency",
                  "altname" => "EUR.HOLD",
                  "decimals" => 4,
                  "display_decimals" => 2
                }
              }
            }
          }

        _ ->
          %Tesla.Env{status: 404, body: "NotFound"}
      end
    end)

    :ok
  end

  test "status returns online" do
    assert KrakenClient.status() == :online
  end

  test "assets returns available assets" do
    assert KrakenClient.assets() == ["EUR.HOLD", "KAVA.S", "REPV2"]
  end

  test "pairs returns available trading pairs" do
    assert KrakenClient.pairs() == ["BTCUSD", "ETHBTC", "ETHUSD"]
  end
end
