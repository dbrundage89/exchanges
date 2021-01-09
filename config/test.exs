use Mix.Config

# config/test.exs
config :tesla, adapter: Tesla.Mock

# in case MyClient defines specific adapter with `adapter SpecificAdapter`
config :tesla, MyClient, adapter: Tesla.Mock
