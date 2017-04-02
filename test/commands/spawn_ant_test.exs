defmodule SpawnAntTest do
  use ExUnit.Case, async: true

  alias AntBattles.Ant
  alias AntBattles.Stores
  alias AntBattles.Message
  alias AntBattles.Nest
  alias AntBattles.Commands.Command
  alias AntBattles.Commands.SpawnAnt

  setup do
    [name: AntBattles.WorldHelper.create()]
  end

  test "it spawns an ant", context do
    command = %SpawnAnt{nest_id: 1}
    name = context[:name]
    Stores.Nests.register(name, %Nest{id: 1, food: 1})

    :ok = Command.execute(command, name)

    [ant] = Stores.Ants.all(name)
    assert ant.nest_id() == 1
  end

  test "it sends a success message", context do
    name = context[:name]
    command = %SpawnAnt{nest_id: 2}
    ant = %Ant{id: 1, nest_id: 2, pos: {0, 0}, team: "me"}
    Stores.Ants.add(name, ant)
    message = Message.with_surroundings(ant, name)

    assert {:ok, ^message} = Command.success(command, name)
  end

  test "it sends a failure message", context do
    assert {:error, :insufficient_food} = Command.failure(%SpawnAnt{}, context[:name])
  end
end
