defmodule AntBattles.WorldHelper do
  alias AntBattles.Stores

  def create do
    name = System.system_time |> to_string

    Stores.Ants.start_link(name)
    Stores.Food.start_link(name, 0, 0)
    Stores.Nests.start_link(name)

    name
  end
end
