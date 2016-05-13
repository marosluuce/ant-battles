defmodule AntBattles do
  use Application

  def start(_type, [delay: delay]) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Engine, [delay]),
      Plug.Adapters.Cowboy.child_spec(:http, Router, [], [port: 4000])
    ]

    opts = [strategy: :one_for_one]

    Supervisor.start_link(children, opts)
  end
end
