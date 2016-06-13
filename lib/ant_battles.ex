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
    types = [delay: :integer, food_stacks: :integer, food_stack_size: :integer]

    System.argv()
    |> OptionParser.parse(strict: types)
    |> elem(0)
  end
end
