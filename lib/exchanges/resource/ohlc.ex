defmodule Exchanges.Resource.OHLC do
  defstruct open_time: nil,
            open: nil,
            high: nil,
            low: nil,
            close: nil,
            volume: nil,
            close_time: nil,
            quote_asset_volume: nil,
            number_of_trades: nil,
            taker_buy_base_asset_volume: nil,
            taker_buy_quote_asset_volume: nil

  def from_binance(kline) do
    [
      open_time,
      open,
      high,
      low,
      close,
      volume,
      close_time,
      quote_asset_volume,
      number_of_trades,
      taker_buy_base_asset_volume,
      taker_buy_quote_asset_volume | _
    ] = kline

    %Exchanges.Resource.OHLC{
      open_time: open_time,
      open: open,
      high: high,
      low: low,
      close: close,
      volume: volume,
      close_time: close_time,
      quote_asset_volume: quote_asset_volume,
      number_of_trades: number_of_trades,
      taker_buy_base_asset_volume: taker_buy_base_asset_volume,
      taker_buy_quote_asset_volume: taker_buy_quote_asset_volume
    }
  end
end
