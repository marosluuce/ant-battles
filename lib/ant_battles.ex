defmodule AntBattles do
  use Application

  def start(_type, [delay]) do
    Engine.start_link(delay)
    Plug.Adapters.Cowboy.http(Router, [])

    Supervisor.start_link([], strategy: :one_for_one)
  end
end
