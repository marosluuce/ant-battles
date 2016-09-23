use Mix.Config

config :ant_battles, AntBattles.Endpoint,
  http: [port: 4001],
  server: false

config :logger, level: :warn
