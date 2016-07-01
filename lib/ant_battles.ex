defmodule AntBattles do
  use Application

  def start(_, _) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Engine, [command_line_args()]),
      Plug.Adapters.Cowboy.child_spec(:http, Router, [], [port: 4000, dispatch: dispatch(), acceptors: 1000])
    ]

    opts = [strategy: :one_for_one]

    Supervisor.start_link(children, opts)
  end

  def dispatch do
    [{:_, [{"/ws", Websocket, []}, {:_, Plug.Adapters.Cowboy.Handler, {Router, []}}]}]
  end

  def command_line_args do
    delay = Application.get_env(:ant_battles, :delay)  |> default(200)
    food_stacks = Application.get_env(:ant_battles, :food_stacks)  |> default(100)
    food_stack_size = Application.get_env(:ant_battles, :food_stack_size)  |> default(10)

    [delay: delay, food_stacks: food_stacks, food_stack_size: food_stack_size]
  end

  def default(value, _) when is_integer(value), do: value
  def default(_, other), do: other
end
