defmodule JoinTest do
  use ExUnit.Case, async: true

  alias AntBattles.Stores
  alias AntBattles.Message
  alias AntBattles.Commands.Command
  alias AntBattles.Commands.Join

  setup do
    [name: AntBattles.WorldHelper.create()]
  end

  test "it registers a user", context do
    :ok = Command.execute(%Join{team: "name"}, context[:name])

    assert 1 == Stores.Nests.all(context[:name]) |> Enum.count
  end

  test "it sends a success message", context do
    name = context[:name]
    :ok = Command.execute(%Join{team: "name"}, name)
    message = Message.details(Stores.Nests.find_by_name(name, "name"))

    assert {:ok, message} == Command.success(%Join{team: "name"}, name)
  end

  test "it sends a failure message", context do
    assert {:error, :name_taken} = Command.failure(%Join{}, context[:name])
  end
end
