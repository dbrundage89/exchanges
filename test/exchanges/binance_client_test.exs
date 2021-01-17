defmodule Exchanges.BinanceClientTest do
  use ExUnit.Case
  alias Exchanges.BinanceClient

  setup do
    Tesla.Mock.mock(fn env ->
      case env.url do
        "https://api.binance.us/api/v3/ping" ->
          %Tesla.Env{
            status: 200
          }

        "https://api.binance.us/api/v3/exchangeInfo" ->
          %Tesla.Env{
            body: %{
              "timezone" => "UTC",
              "serverTime" => 1_565_246_363_776,
              "rateLimits" => [
                {}
              ],
              "exchangeFilters" => [],
              "symbols" => [
                %{
                  "symbol" => "ETHBTC",
                  "status" => "TRADING",
                  "baseAsset" => "ETH",
                  "baseAssetPrecision" => 8,
                  "quoteAsset" => "BTC",
                  "quotePrecision" => 8,
                  "quoteAssetPrecision" => 8,
                  "baseCommissionPrecision" => 8,
                  "quoteCommissionPrecision" => 8,
                  "orderTypes" => [
                    "LIMIT",
                    "LIMIT_MAKER",
                    "MARKET",
                    "STOP_LOSS",
                    "STOP_LOSS_LIMIT",
                    "TAKE_PROFIT",
                    "TAKE_PROFIT_LIMIT"
                  ],
                  "icebergAllowed" => true,
                  "ocoAllowed" => true,
                  "quoteOrderQtyMarketAllowed" => true,
                  "isSpotTradingAllowed" => true,
                  "isMarginTradingAllowed" => false,
                  "filters" => [
                    %{
                      "filterType" => "PRICE_FILTER",
                      "maxPrice" => "100000.00000000",
                      "minPrice" => "0.01000000",
                      "tickSize" => "0.01000000"
                    },
                    %{
                      "avgPriceMins" => 5,
                      "filterType" => "PERCENT_PRICE",
                      "multiplierDown" => "0.2",
                      "multiplierUp" => "5"
                    },
                    %{
                      "filterType" => "LOT_SIZE",
                      "maxQty" => "9000.00000000",
                      "minQty" => "0.00001000",
                      "stepSize" => "0.00001000"
                    },
                    %{
                      "applyToMarket" => true,
                      "avgPriceMins" => 5,
                      "filterType" => "MIN_NOTIONAL",
                      "minNotional" => "10.00000000"
                    },
                    %{"filterType" => "ICEBERG_PARTS", "limit" => 10},
                    %{
                      "filterType" => "MARKET_LOT_SIZE",
                      "maxQty" => "22000.00000000",
                      "minQty" => "0.00000000",
                      "stepSize" => "0.00000000"
                    },
                    %{"filterType" => "MAX_NUM_ALGO_ORDERS", "maxNumAlgoOrders" => 5},
                    %{"filterType" => "MAX_NUM_ORDERS", "maxNumOrders" => 200}
                  ]
                },
                %{
                  "symbol" => "LTCETH",
                  "status" => "TRADING",
                  "baseAsset" => "LTC",
                  "baseAssetPrecision" => 7,
                  "quoteAsset" => "ETH",
                  "quotePrecision" => 6,
                  "quoteAssetPrecision" => 8,
                  "baseCommissionPrecision" => 8,
                  "quoteCommissionPrecision" => 8,
                  "orderTypes" => [
                    "LIMIT",
                    "LIMIT_MAKER",
                    "MARKET",
                    "STOP_LOSS",
                    "STOP_LOSS_LIMIT",
                    "TAKE_PROFIT",
                    "TAKE_PROFIT_LIMIT"
                  ],
                  "icebergAllowed" => true,
                  "ocoAllowed" => true,
                  "quoteOrderQtyMarketAllowed" => true,
                  "isSpotTradingAllowed" => true,
                  "isMarginTradingAllowed" => false,
                  "filters" => [
                    %{
                      "filterType" => "PRICE_FILTER",
                      "maxPrice" => "100000.00000000",
                      "minPrice" => "0.01000000",
                      "tickSize" => "0.00010000"
                    },
                    %{
                      "avgPriceMins" => 5,
                      "filterType" => "PERCENT_PRICE",
                      "multiplierDown" => "0.2",
                      "multiplierUp" => "5"
                    },
                    %{
                      "filterType" => "LOT_SIZE",
                      "maxQty" => "9000.00000000",
                      "minQty" => "50",
                      "stepSize" => "0.00002000"
                    },
                    %{
                      "applyToMarket" => true,
                      "avgPriceMins" => 5,
                      "filterType" => "MIN_NOTIONAL",
                      "minNotional" => "10.00000000"
                    },
                    %{"filterType" => "ICEBERG_PARTS", "limit" => 10},
                    %{
                      "filterType" => "MARKET_LOT_SIZE",
                      "maxQty" => "22000.00000000",
                      "minQty" => "0.00000000",
                      "stepSize" => "0.00000000"
                    },
                    %{"filterType" => "MAX_NUM_ALGO_ORDERS", "maxNumAlgoOrders" => 5},
                    %{"filterType" => "MAX_NUM_ORDERS", "maxNumOrders" => 200}
                  ]
                }
              ],
              "permissions" => [
                "SPOT"
              ]
            }
          }

        _ ->
          %Tesla.Env{status: 404, body: "NotFound"}
      end
    end)

    :ok
  end

  test "status returns online" do
    assert BinanceClient.status() == :online
  end

  test "assets returns available assets" do
    assert BinanceClient.assets() == ["BTC, ETH, DAI"]
  end

  test "assetPairs returns available trading pairs" do
    assert BinanceClient.assetPairs() == [
             %{
               name: "ETHBTC",
               base: "ETH",
               lot_stepSize: 0.00001,
               ordermin: 0.00001000,
               price_stepSize: 0.01,
               quote: "BTC"
             },
             %{
               name: "LTCETH",
               base: "LTC",
               lot_stepSize: 0.00002,
               ordermin: 50,
               price_stepSize: 0.0001,
               quote: "ETH"
             }
           ]
  end
end
