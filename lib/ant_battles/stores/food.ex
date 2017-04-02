defmodule AntBattles.Stores.Food do
  alias AntBattles.Location
  alias AntBattles.Food

  def start_link(name, stack_size, stack_count) do
    {:ok, pid} = Agent.start_link(fn -> %{} end, name: via(name))
    Enum.each(
      1..stack_count,
      fn _ -> add_food(name, Location.random(50), stack_size) end
    )
    {:ok, pid}
  end

  def via(name) do
    {:via, Registry, {Registry.ViaAntBattles, {:food, name}}}
  end

  def add_food(name, location, quantity) do
    Agent.update(via(name), &Map.put(&1, location, Food.create(location, quantity)))
  end

  def take_food(name, location, quantity) do
    Agent.get_and_update(
      via(name),
      fn food ->
        update = Map.update(food, location, Food.create(location, 0), fn f -> %{f | quantity: f.quantity - quantity} end)
        {update[location], update}
      end
    )
  end

  def all(name) do
    name
    |> via
    |> Agent.get(&Map.values/1)
    |> Enum.filter(fn f -> f.quantity > 0 end)
  end
end
