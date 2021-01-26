defmodule Exchanges.KrakenClientTest do
  use ExUnit.Case
  # doctest Exchanges.KrakenClient - todo: research what this is?
  alias Exchanges.KrakenClient
  alias Exchanges.Resource

  setup do
    Tesla.Mock.mock(fn env ->
      case env.url do
        "https://api.kraken.com/0/public/SystemStatus" ->
          %Tesla.Env{
            body: %{
              error: [],
              result: %{status: "online", timestamp: "2021-01-26T14:58:01Z"}
            }
          }

        "https://api.kraken.com/0/public/Assets" ->
          %Tesla.Env{
            body: %{
              error: [],
              result: %{
                "USD.M7": %{
                  aclass: "currency",
                  altname: "USD.M7",
                  decimals: 4,
                  display_decimals: 4
                },
                ICX: %{
                  aclass: "currency",
                  altname: "ICX",
                  decimals: 10,
                  display_decimals: 5
                },
                ANT: %{
                  aclass: "currency",
                  altname: "ANT",
                  decimals: 10,
                  display_decimals: 5
                }
              }
            }
          }

        "https://api.kraken.com/0/public/AssetPairs" ->
          %Tesla.Env{
            body: %{
              error: [],
              result: %{
                ADAUSD: %{
                  aclass_base: "currency",
                  aclass_quote: "currency",
                  altname: "ADAUSD",
                  base: "ADA",
                  fee_volume_currency: "ZUSD",
                  fees: [
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
                  fees_maker: [
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
                  leverage_buy: [],
                  leverage_sell: [],
                  lot: "unit",
                  lot_decimals: 4,
                  lot_multiplier: 1,
                  margin_call: 80,
                  margin_stop: 40,
                  ordermin: "50",
                  pair_decimals: 3,
                  quote: "ZUSD",
                  wsname: "REPV2/USD"
                },
                XREPZUSD: %{
                  aclass_base: "currency",
                  aclass_quote: "currency",
                  altname: "REPUSD",
                  base: "XREP",
                  fee_volume_currency: "ZUSD",
                  fees: [
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
                  fees_maker: [
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
                  leverage_buy: [],
                  leverage_sell: [],
                  lot: "unit",
                  lot_decimals: 8,
                  lot_multiplier: 1,
                  margin_call: 80,
                  margin_stop: 40,
                  pair_decimals: 3,
                  quote: "ZUSD",
                  wsname: "REP/USD"
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
    assert KrakenClient.assets() == ["ANT", "ICX", "USD.M7"]
  end

  test "assetPairs returns available trading pairs" do
    assert KrakenClient.asset_pairs() == [
             %Exchanges.Resource.AssetPair{
               base: "ADA",
               lot_stepsize: 0.0001,
               ordermin: 50.0,
               price_stepsize: 0.001,
               quote: "ZUSD",
               symbol: "ADAUSD"
             },
             %Exchanges.Resource.AssetPair{
               base: "XREP",
               lot_stepsize: 1.0e-8,
               ordermin: 0,
               price_stepsize: 0.001,
               quote: "ZUSD",
               symbol: "XREPZUSD"
             }
           ]
  end
end
