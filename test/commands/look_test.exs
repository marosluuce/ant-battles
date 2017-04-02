defmodule LookTest do
  use ExUnit.Case, async: true

  alias AntBattles.Ant
  alias AntBattles.Stores
  alias AntBattles.Message
  alias AntBattles.Commands.Command
  alias AntBattles.Commands.Look

  setup do
    [name: AntBattles.WorldHelper.create()]
  end

  test "looking succeeds when the ant exists", context do
    name = context[:name]
    Stores.Ants.add(name, %Ant{id: 1})
    assert :ok = Command.execute(%Look{ant_id: 1}, name)
  end

  test "looking errors when the ant does not exist", context do
    assert :error == Command.execute(%Look{ant_id: 1}, context[:name])
  end

  test "sending a success message", context do
    name = context[:name]
    Stores.Ants.add(name, %Ant{id: 1})
    message = Message.with_surroundings(%Ant{id: 1}, name)

    assert {:ok, message} == Command.success(%Look{ant_id: 1}, name)
  end

  test "sending a failure message", context do
    assert {:error, :invalid_id} = Command.failure(%Look{}, context[:name])
  end
end
