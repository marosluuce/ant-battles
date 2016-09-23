defmodule AntBattles do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(AntBattles.Endpoint, []),
      worker(AntBattles.Engine, [[food_stacks: 50, food_stack_size: 100]])
    ]

    opts = [strategy: :one_for_one, name: AntBattles.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    AntBattles.Endpoint.config_change(changed, removed)
    :ok
  end
end
