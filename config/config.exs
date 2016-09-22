use Mix.Config

config :ant_battles, AntBattles.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "eWVg01ZE/y5qFrN0/vCf1kC1vZ4Y6JSU4zw9m28wWqLjMCFPq1FXndOhDaEApdhn",
  render_errors: [view: AntBattles.ErrorView, accepts: ~w(html json)],
  pubsub: [name: AntBattles.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

import_config "#{Mix.env}.exs"
