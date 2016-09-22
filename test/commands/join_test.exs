defmodule JoinTest do
  use ExUnit.Case, async: true

  alias AntBattles.World
  alias AntBattles.Message
  alias AntBattles.Commands.Command
  alias AntBattles.Commands.Join


  test "it registers a user" do
    {:ok, world} = Command.execute(%Join{team: "name"}, %World{})

    assert Enum.count(world.nests) == 1
  end

  test "it sends a success message" do
    {:ok, world} = Command.execute(%Join{team: "name"}, %World{})
    message = Message.details(Enum.at(world.nests, 0))

    assert {:ok, message} == Command.success(%Join{team: "name"}, world)
  end

  test "it sends a failure message" do
    assert {:error, :name_taken} = Command.failure(%Join{}, %World{})
  end
end
