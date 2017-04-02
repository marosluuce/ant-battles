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

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: via(name))
  end

  def init(engine), do: {:ok, engine}

  def handle_call(:get_world, _, name) do
    {:reply, name, name}
  end

  def handle_call({:run, command}, _, name) do
    case Command.execute(command, name) do
      :error ->
        {:reply, {:error, {command, name}}, name}
      _  ->
        {:reply, {:ok, {command, name}}, name}
    end
  end

  def join(name, team) do
    execute(name, %Join{team: team})
  end

  def spawn_ant(name, nest_id) do
    execute(name, %SpawnAnt{nest_id: nest_id})
  end

  def move_ant(name, ant_id, direction) do
    execute(name, %MoveAnt{ant_id: ant_id, velocity: Move.from_dir(direction)})
  end

  def look(name, ant_id) do
    execute(name, %Look{ant_id: ant_id})
  end

  def observe(name) do
    execute(name, %Observe{})
  end

  def add_food(name, location, quantity) do
    execute(name, %AddFood{location: location, quantity: quantity})
  end

  defp notify({:ok, {command, name}}), do: Command.success(command, name)
  defp notify({:error, {command, name}}), do: Command.failure(command, name)

  def info(name, id) do
    get_world(name)
    |> World.find(id)
    |> format_info
  end

  defp format_info({:error, :not_found}), do: {:error, :invalid_id}
  defp format_info(entity), do: {:ok, Message.details(entity)}

  defp get_world(name), do: GenServer.call(via(name), :get_world)

  defp execute(name, command) do
    GenServer.call(via(name), {:run, command}) |> notify
  end

  def via(name) do
    {:via, Registry, {Registry.ViaAntBattles, {:engine, name}}}
  end
end
