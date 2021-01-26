defmodule Exchanges.BinanceClientTest do
  use ExUnit.Case
  alias Exchanges.BinanceClient
  alias Exchanges.Resource

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
              exchangeFilters: [],
              rateLimits: [
                %{
                  interval: "MINUTE",
                  intervalNum: 1,
                  limit: 1200,
                  rateLimitType: "REQUEST_WEIGHT"
                },
                %{
                  interval: "SECOND",
                  intervalNum: 10,
                  limit: 100,
                  rateLimitType: "ORDERS"
                },
                %{
                  interval: "DAY",
                  intervalNum: 1,
                  limit: 200_000,
                  rateLimitType: "ORDERS"
                }
              ],
              serverTime: 1_611_266_074_168,
              symbols: [
                %{
                  baseAsset: "ETH",
                  baseAssetPrecision: 8,
                  baseCommissionPrecision: 8,
                  filters: [
                    %{
                      filterType: "PRICE_FILTER",
                      maxPrice: "100000.000000",
                      minPrice: "0.01000000",
                      tickSize: "0.01000000"
                    },
                    %{
                      avgPriceMins: 5,
                      filterType: "PERCENT_PRICE",
                      multiplierDown: "0.2",
                      multiplierUp: "5"
                    },
                    %{
                      filterType: "LOT_SIZE",
                      maxQty: "9000.00000000",
                      minQty: "0.0000100",
                      stepSize: "0.0000100"
                    },
                    %{
                      applyToMarket: true,
                      avgPriceMins: 5,
                      filterType: "MIN_NOTIONAL",
                      minNotional: "10.00000000"
                    },
                    %{filterType: "ICEBERG_PARTS", limit: 10},
                    %{
                      filterType: "MARKET_LOT_SIZE",
                      maxQty: "3200.00000000",
                      minQty: "0.00000000",
                      stepSize: "0.00000000"
                    },
                    %{filterType: "MAX_NUM_ALGO_ORDERS", maxNumAlgoOrders: 5},
                    %{filterType: "MAX_NUM_ORDERS", maxNumOrders: 200}
                  ],
                  icebergAllowed: true,
                  isMarginTradingAllowed: false,
                  isSpotTradingAllowed: true,
                  ocoAllowed: true,
                  orderTypes: [
                    "LIMIT",
                    "LIMIT_MAKER",
                    "MARKET",
                    "STOP_LOSS_LIMIT",
                    "TAKE_PROFIT_LIMIT"
                  ],
                  permissions: ["SPOT"],
                  quoteAsset: "BTC",
                  quoteAssetPrecision: 8,
                  quoteCommissionPrecision: 8,
                  quoteOrderQtyMarketAllowed: true,
                  quotePrecision: 8,
                  status: "TRADING",
                  symbol: "ETHBTC"
                },
                %{
                  baseAsset: "LTC",
                  baseAssetPrecision: 7,
                  baseCommissionPrecision: 8,
                  filters: [
                    %{
                      filterType: "PRICE_FILTER",
                      maxPrice: "100000.0000",
                      minPrice: "0.0100",
                      tickSize: "0.00010000"
                    },
                    %{
                      avgPriceMins: 5,
                      filterType: "PERCENT_PRICE",
                      multiplierDown: "0.2",
                      multiplierUp: "5"
                    },
                    %{
                      filterType: "LOT_SIZE",
                      maxQty: "9000.00000000",
                      minQty: "50",
                      stepSize: "0.00002000"
                    },
                    %{
                      applyToMarket: true,
                      avgPriceMins: 5,
                      filterType: "MIN_NOTIONAL",
                      minNotional: "10.0000"
                    },
                    %{filterType: "ICEBERG_PARTS", limit: 10},
                    %{
                      filterType: "MARKET_LOT_SIZE",
                      maxQty: "50000.00000000",
                      minQty: "0.00000000",
                      stepSize: "0.00000000"
                    },
                    %{filterType: "MAX_NUM_ORDERS", maxNumOrders: 200},
                    %{filterType: "MAX_NUM_ALGO_ORDERS", maxNumAlgoOrders: 5}
                  ],
                  icebergAllowed: true,
                  isMarginTradingAllowed: false,
                  isSpotTradingAllowed: true,
                  ocoAllowed: true,
                  orderTypes: [
                    "LIMIT",
                    "LIMIT_MAKER",
                    "MARKET",
                    "STOP_LOSS_LIMIT",
                    "TAKE_PROFIT_LIMIT"
                  ],
                  permissions: ["SPOT"],
                  quoteAsset: "ETH",
                  quoteAssetPrecision: 4,
                  quoteCommissionPrecision: 2,
                  quoteOrderQtyMarketAllowed: true,
                  quotePrecision: 4,
                  status: "TRADING",
                  symbol: "LTCETH"
                }
              ]
            }
          }

        "https://api.binance.us/api/v3/ticker/price" ->
          %Tesla.Env{
            __client__: %Tesla.Client{adapter: nil, fun: nil, post: [], pre: []},
            __module__: Exchanges.BinanceClient,
            body: [
              %{:price => "36322.0600", :symbol => "BTCUSD"},
              %{:price => "1239.7400", :symbol => "ETHUSD"},
              %{:price => "0.2970", :symbol => "XRPUSD"},
              %{:price => "495.2400", :symbol => "BCHUSD"}
            ]
          }

        "https://api.binance.us/api/v3/klines?symbol=BTCUSD&interval=1m" ->
          %Tesla.Env{
            __client__: %Tesla.Client{adapter: nil, fun: nil, post: [], pre: []},
            __module__: Exchanges.BinanceClient,
            body: [
              [
                1_611_660_420_000,
                "31940.6600",
                "31940.6600",
                "31895.9200",
                "31926.3700",
                "0.32096200",
                1_611_660_479_999,
                "10240.5104",
                18,
                "0.02428400",
                "774.8209",
                "0"
              ],
              [
                1_611_660_480_000,
                "31922.8600",
                "31948.1400",
                "31922.8600",
                "31934.1100",
                "0.02782800",
                1_611_660_539_999,
                "888.7111",
                7,
                "0.01651400",
                "527.3238",
                "0"
              ]
            ]
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
    assert BinanceClient.assets() == ["BTC", "ETH", "LTC"]
  end

  test "asset_pairs returns available trading pairs" do
    assert BinanceClient.asset_pairs() == [
             %Resource.AssetPair{
               symbol: "ETHBTC",
               base: "ETH",
               lot_stepsize: 0.00001,
               ordermin: 0.00001000,
               price_stepsize: 0.01,
               quote: "BTC"
             },
             %Resource.AssetPair{
               symbol: "LTCETH",
               base: "LTC",
               lot_stepsize: 0.00002,
               ordermin: 50,
               price_stepsize: 0.0001,
               quote: "ETH"
             }
           ]
  end

  test "prices returns prices for every symbol" do
    assert BinanceClient.prices() == [
             %Resource.Price{:price => "36322.0600", :symbol => "BTCUSD"},
             %Resource.Price{:price => "1239.7400", :symbol => "ETHUSD"},
             %Resource.Price{:price => "0.2970", :symbol => "XRPUSD"},
             %Resource.Price{:price => "495.2400", :symbol => "BCHUSD"}
           ]
  end

  test "ohlc called with BTCUSD and 1m returns 1m ohlc data" do
    assert BinanceClient.ohlc("BTCUSD", "1m") == [
             %Resource.OHLC{
               open_time: 1_611_660_420_000,
               open: "31940.6600",
               high: "31940.6600",
               low: "31895.9200",
               close: "31926.3700",
               volume: "0.32096200",
               close_time: 1_611_660_479_999,
               quote_asset_volume: "10240.5104",
               number_of_trades: 18,
               taker_buy_base_asset_volume: "0.02428400",
               taker_buy_quote_asset_volume: "774.8209"
             },
             %Resource.OHLC{
               open_time: 1_611_660_480_000,
               open: "31922.8600",
               high: "31948.1400",
               low: "31922.8600",
               close: "31934.1100",
               volume: "0.02782800",
               close_time: 1_611_660_539_999,
               quote_asset_volume: "888.7111",
               number_of_trades: 7,
               taker_buy_base_asset_volume: "0.01651400",
               taker_buy_quote_asset_volume: "527.3238"
             }
           ]
  end
end
