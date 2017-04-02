defmodule AntBattles do
  use Application

  @engine Application.get_env(:ant_battles, :engine)
  @stack_size 50
  @stack_count 100

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(AntBattles.Endpoint, []),
      supervisor(Registry, [:unique, AntBattles.Registry.name()]),
      worker(AntBattles.Engine, [@engine]),
      worker(AntBattles.Stores.Ants, [@engine]),
      worker(AntBattles.Stores.Food, [@engine, @stack_size, @stack_count]),
      worker(AntBattles.Stores.Nests, [@engine]),
      worker(AntBattles.Broadcaster, [200])
    ]

    opts = [strategy: :one_for_one, name: AntBattles.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    AntBattles.Endpoint.config_change(changed, removed)
    :ok
  end
end
