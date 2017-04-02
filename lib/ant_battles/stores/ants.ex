defmodule AntBattles.Stores.Ants do

  def start_link(name) do
    Agent.start_link(fn -> %{} end, name: via(name))
  end

  def via(name) do
    {:via, Registry, {Registry.ViaAntBattles, {:ants, name}}}
  end

  def add(name, ant) do
    Agent.update(via(name), &Map.put(&1, ant.id, ant))
  end

  def all(name) do
    Agent.get(via(name), &Map.values/1)
  end

  def update(name, ant) do
    Agent.update(via(name), &Map.put(&1, ant.id, ant))
  end

  def get_map(name) do
    Agent.get(via(name), fn n -> n end)
  end

  def get(name, id) do
    Agent.get(via(name), &Map.get(&1, id))
  end

  def ants_by_nest_id(name, id) do
    name
    |> all
    |> Enum.filter(fn ant -> ant.nest_id == id end)
  end
end
