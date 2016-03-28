defmodule RegisterTest do
  use ExUnit.Case

  test "it registers a user" do
    {:ok, world} = Command.execute(%Register{name: "name"}, %World{})

    assert world |> World.nests |> Enum.count == 1
  end

  test "it sends a success message" do
    {:ok, world} = World.register(%World{}, "name")

    Command.success(%Register{name: "name"}, self(), world)

    [nest] = world |> World.nests
    message = %{position: nest.pos, food: nest.food, id: nest.id}

    assert_received {:ok, ^message}
  end

  test "it sends a failure message" do
    Command.failure(%Register{}, self(), %World{})

    assert_received {:error, :name_taken}
  end
end
