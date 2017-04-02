defmodule AntBattles.Stores.Nests do

  def start_link(name) do
    Agent.start_link(fn -> %{} end, name: via(name))
  end

  def via(name) do
    {:via, Registry, {Registry.ViaAntBattles, {:nests, name}}}
  end

  def registered?(name, team) do
    name
    |> via
    |> Agent.get(&Map.values/1)
    |> Enum.any?(fn nest -> nest.team == team end)
  end

  def register(name, nest) do
    Agent.update(via(name), &Map.put(&1, nest.id, nest))
  end

  def all(name) do
    Agent.get(via(name), &Map.values/1)
  end

  def get_map(name) do
    Agent.get(via(name), fn n -> n end)
  end

  def update_nest(name, nest) do
    Agent.update(via(name), &Map.put(&1, nest.id, nest))
  end

  def find_by_name(name, team) do
    name
    |> all
    |> Enum.find(fn nest -> nest.team == team end)
  end
end
