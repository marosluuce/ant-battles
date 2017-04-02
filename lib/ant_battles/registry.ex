defmodule AntBattles.Registry do
  @name Registry.ViaAntBattles

  def name do
    @name
  end

  def via(name, type) do
    {:via, Registry, {@name, {type, name}}}
  end
end
