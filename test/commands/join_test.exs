defmodule JoinTest do
  use ExUnit.Case, async: true

  test "it registers a user" do
    {:ok, world} = Command.execute(%Join{team: "name"}, %World{})

    assert world |> World.nests |> Enum.count == 1
  end

  test "it sends a success message" do
    {:ok, world} = World.register(%World{}, "name")

    Command.success(%Join{team: "name"}, self(), world)

    [nest] = world |> World.nests
    message = Message.details(nest, world)
    assert_received {:ok, ^message}
  end

  test "it sends a failure message" do
    Command.failure(%Join{}, self(), %World{})

    assert_received {:error, :name_taken}
  end
end
