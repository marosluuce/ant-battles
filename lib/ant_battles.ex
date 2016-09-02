defmodule AntBattles do
  use Application

  def start(_, _) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Engine, [command_line_args()]),
      Plug.Adapters.Cowboy.child_spec(:http, Router, [], [port: 4000, dispatch: dispatch()])
    ]

    opts = [strategy: :one_for_one]

    Supervisor.start_link(children, opts)
  end

  def dispatch do
    [{:_, [{"/ws", Websocket, []}, {:_, Plug.Adapters.Cowboy.Handler, {Router, []}}]}]
  end

  def command_line_args do
    food_stacks = System.get_env("FOOD_STACKS") |> default(100)
    food_stack_size = System.get_env("FOOD_STACK_SIZE")  |> default(10)

    [food_stacks: food_stacks, food_stack_size: food_stack_size]
  end

  def default(nil, other), do: other
  def default(value, other)  do
    case Integer.parse(value) do
      {x, ""} -> x
      _ -> other
    end
  end
end
