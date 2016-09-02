defmodule JoinTest do
  use ExUnit.Case, async: true

  test "it registers a user" do
    {:ok, world} = Command.execute(%Join{team: "name"}, %World{})

    assert world |> World.nests |> Enum.count == 1
  end

  test "it sends a success message" do
    {:ok, world} = World.register(%World{}, "name")
    [nest] = world |> World.nests
    message = Message.details(nest)

    assert {:ok, ^message} = Command.success(%Join{team: "name"}, world)
  end

  test "it sends a failure message" do
    assert {:error, :name_taken} = Command.failure(%Join{}, %World{})
  end
end
