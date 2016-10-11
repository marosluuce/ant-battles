defmodule AntBattles.Engine do
  use GenServer

  alias AntBattles.World
  alias AntBattles.Message
  alias AntBattles.Move
  alias AntBattles.Commands.Command
  alias AntBattles.Commands.Join
  alias AntBattles.Commands.SpawnAnt
  alias AntBattles.Commands.MoveAnt
  alias AntBattles.Commands.Look
  alias AntBattles.Commands.Observe
  alias AntBattles.Commands.AddFood

  def start_link(args) do
    GenServer.start_link(__MODULE__, World.new(args), name: __MODULE__)
  end

  def init(engine), do: {:ok, engine}

  def handle_call(:get_world, _, world) do
    {:reply, world, world}
  end

  def handle_call({:run, command}, _, world) do
    case Command.execute(command, world) do
      {:ok, new_world} ->
        {:reply, Command.success(command, new_world), new_world}
      _  ->
        {:reply, Command.failure(command, world), world}
    end
  end

  def handle_cast(:reset, _) do
    {:noreply, %World{}}
  end

  def join(team), do: execute(%Join{team: team})

  def spawn_ant(nest_id), do: execute(%SpawnAnt{nest_id: nest_id})

  def move_ant(ant_id, direction) do
    execute(%MoveAnt{ant_id: ant_id, velocity: Move.from_dir(direction)})
  end

  def look(ant_id), do: execute(%Look{ant_id: ant_id})

  def observe, do: execute(%Observe{})

  def add_food(location, quantity) do
    execute(%AddFood{location: location, quantity: quantity})
  end

  def reset do
    GenServer.cast(__MODULE__, :reset)
  end

  def info(id) do
    get_world()
    |> World.find(id)
    |> format_info
  end

  defp format_info({:error, :not_found}), do: {:error, :invalid_id}
  defp format_info(entity), do: {:ok, Message.details(entity)}

  defp get_world, do: GenServer.call(__MODULE__, :get_world)

  defp execute(command), do: GenServer.call(__MODULE__, {:run, command})
end
