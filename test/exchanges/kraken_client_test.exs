defmodule Exchanges.KrakenClientTest do
  use ExUnit.Case
  # doctest Exchanges.KrakenClient - todo: research what this is?
  alias Exchanges.KrakenClient

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

        "https://api.kraken.com/0/public/AssetPairs" ->
          %Tesla.Env{
            body: %{
              "error" => [],
              "result" => %{
                "DAIUSD" => %{
                  "aclass_base" => "currency",
                  "aclass_quote" => "currency",
                  "altname" => "DAIUSD",
                  "base" => "DAI",
                  "fee_volume_currency" => "ZUSD",
                  "fees" => [
                    [0, 0.2],
                    [50000, 0.16],
                    [100_000, 0.12],
                    [250_000, 0.08],
                    [500_000, 0.04],
                    [1_000_000, 0]
                  ],
                  "fees_maker" => [
                    [0, 0.2],
                    [50000, 0.16],
                    [100_000, 0.12],
                    [250_000, 0.08],
                    [500_000, 0.04],
                    [1_000_000, 0]
                  ],
                  "leverage_buy" => [],
                  "leverage_sell" => [],
                  "lot" => "unit",
                  "lot_decimals" => 8,
                  "lot_multiplier" => 1,
                  "margin_call" => 80,
                  "margin_stop" => 40,
                  "ordermin" => "10",
                  "pair_decimals" => 5,
                  "quote" => "ZUSD",
                  "wsname" => "DAI/USD"
                },
                "ADAUSD" => %{
                  "aclass_base" => "currency",
                  "aclass_quote" => "currency",
                  "altname" => "ADAUSD",
                  "base" => "ADA",
                  "fee_volume_currency" => "ZUSD",
                  "fees" => [
                    [0, 0.26],
                    [50000, 0.24],
                    [100_000, 0.22],
                    [250_000, 0.2],
                    [500_000, 0.18],
                    [1_000_000, 0.16],
                    [2_500_000, 0.14],
                    [5_000_000, 0.12],
                    [10_000_000, 0.1]
                  ],
                  "fees_maker" => [
                    [0, 0.16],
                    [50000, 0.14],
                    [100_000, 0.12],
                    [250_000, 0.1],
                    [500_000, 0.08],
                    [1_000_000, 0.06],
                    [2_500_000, 0.04],
                    [5_000_000, 0.02],
                    [10_000_000, 0]
                  ],
                  "leverage_buy" => [2, 3],
                  "leverage_sell" => [2, 3],
                  "lot" => "unit",
                  "lot_decimals" => 8,
                  "lot_multiplier" => 1,
                  "margin_call" => 80,
                  "margin_stop" => 40,
                  "ordermin" => "50",
                  "pair_decimals" => 6,
                  "quote" => "ZUSD",
                  "wsname" => "ADA/USD"
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

  test "assetPairs returns available trading pairs" do
    assert KrakenClient.assetPairs() == [
             %{
               name: "ADAUSD",
               base: "ADA",
               lot_stepSize: 0.00000001,
               ordermin: 50,
               price_stepSize: 0.000001,
               quote: "ZUSD"
             },
             %{
               name: "DAIUSD",
               base: "DAI",
               lot_stepSize: 0.00000001,
               ordermin: 10,
               price_stepSize: 0.00001,
               quote: "ZUSD"
             }
           ]
  end
end
