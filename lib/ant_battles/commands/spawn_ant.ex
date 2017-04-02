defmodule AntBattles.Commands.SpawnAnt do
  defstruct nest_id: -1
end

defimpl AntBattles.Commands.Command, for: AntBattles.Commands.SpawnAnt do
  alias AntBattles.Ant
  alias AntBattles.Stores
  alias AntBattles.Nest
  alias AntBattles.World
  alias AntBattles.Message

  def execute(command, name) do
    spawn_ant(name, command.nest_id)
  end

  def success(command, name) do
    message = name
    |> World.newest_ant(command.nest_id)
    |> Message.with_surroundings(name)

    {:ok, message}
  end

  def failure(_, _), do: {:error, :insufficient_food}

  def spawn_ant(name, nest_id) do
    name
    |> find(nest_id)
    |> do_spawn_ant(name)
  end

  defp do_spawn_ant({:error, _}, _), do: {:error, :unknown_nest}
  defp do_spawn_ant(nest, name) do
    spawn_ant(name, nest.id, Nest.spawn_ant(nest))
  end

  defp spawn_ant(_, _, {:error, msg}), do: {:error, msg}
  defp spawn_ant(name, _, nest) do
    Stores.Nests.update_nest(name, nest)
    Stores.Ants.add(name, Ant.create(AntBattles.Id.random(), nest))
    :ok
  end

  def find(name, id) do
    case Stores.Nests.get_map(name) |> Map.fetch(id) do
      :error -> {:error, :not_found}
      {:ok, thing} -> thing
    end
  end
end
