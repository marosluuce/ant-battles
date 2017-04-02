defmodule AntBattles.Commands.MoveAnt do
  defstruct ant_id: -1, velocity: {0, 0}
end

defimpl AntBattles.Commands.Command, for: AntBattles.Commands.MoveAnt do
  alias AntBattles.Ant
  alias AntBattles.Stores
  alias AntBattles.Nest
  alias AntBattles.Message

  def execute(command, name) do
    move_ant(name, command.ant_id, command.velocity)
  end

  def success(command, name) do
    message = Stores.Ants.get(name, command.ant_id)
    |> Message.with_surroundings(name)

    {:ok, message}
  end

  def failure(_, _), do: {:error, :invalid_id}

  def move_ant(name, ant_id, direction) do
    ant = find(name, ant_id)
    do_move_ant(ant, name, direction)
  end

  def find(name, id) do
    case Stores.Ants.get_map(name) |> Map.fetch(id) do
      :error -> {:error, :not_found}
      {:ok, thing} -> thing
    end
  end

  defp do_move_ant({:error, _}, _, _), do: {:error, :unknown_ant}
  defp do_move_ant(ant, name, direction) do
    moved_ant = Ant.move(ant, direction)

    cond do
      ant_found_food?(name, moved_ant) -> ant_gets_food(name, moved_ant)

      ant_delivered_food?(name, moved_ant) ->
        ant_delivers_food(name, moved_ant)
        :ok

      true ->
        Stores.Ants.update(name, moved_ant)
        :ok
    end
  end

  defp ant_found_food?(_, %Ant{has_food: true}), do: false
  defp ant_found_food?(name, ant), do: Stores.Food.take_food(name, ant.pos, 1) > 0

  defp ant_gets_food(name, ant) do
    Stores.Ants.update(name, Ant.pick_up_food(ant))
    :ok
  end

  defp ant_delivered_food?(name, ant), do: ant_reached_own_nest?(name, ant) && ant.has_food

  defp ant_delivers_food(name, ant) do
    nest = find(name, ant.nest_id)

    Stores.Nests.update_nest(name, Nest.deliver_food(nest))
    Stores.Ants.update(name, Ant.drop_food(ant))
  end

  defp ant_reached_own_nest?(name, ant) do
    case AntBattles.World.find(name, ant.nest_id) do
      %Nest{pos: pos} -> pos == ant.pos
      _ -> false
    end
  end
end
