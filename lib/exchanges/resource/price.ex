defmodule Exchanges.Resource.Price do
  defstruct(price: nil, symbol: nil)

  def from_binance(price) do
    struct(Exchanges.Resource.Price, price)
  end
end
