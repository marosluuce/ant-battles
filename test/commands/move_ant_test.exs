defmodule MoveAntTest do
  use ExUnit.Case, async: true

  alias AntBattles.Ant
  alias AntBattles.Stores
  alias AntBattles.Message
  alias AntBattles.Commands.Command
  alias AntBattles.Commands.MoveAnt

  setup do
    [name: AntBattles.WorldHelper.create()]
  end

  test "it moves an ant", context do
    name = context[:name]
    Stores.Ants.update(name, %Ant{id: 1, pos: {2, 3}})
    command = %MoveAnt{ant_id: 1, velocity: {0, 1}}

    :ok = Command.execute(command, name)

    [ant] = Stores.Ants.all(name)
    assert ant.pos == {2, 4}
  end

  test "it sends a success message", context do
    name = context[:name]
    command = %MoveAnt{ant_id: 1}
    ant = %Ant{id: 1, pos: {2, 4}}
    Stores.Ants.update(name, ant)
    message = Message.with_surroundings(ant, name)

    assert {:ok, ^message} = Command.success(command, name)
  end

  test "it sends a failure message", context do
    assert {:error, :invalid_id} = Command.failure(%MoveAnt{ant_id: 1}, context[:name])
  end
end
