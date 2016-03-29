defmodule JoinTest do
  use ExUnit.Case

  test "it registers a user" do
    {:ok, world} = Command.execute(%Join{name: "name"}, %World{})

    assert world |> World.nests |> Enum.count == 1
  end

  test "it sends a success message" do
    {:ok, world} = World.register(%World{}, "name")

    Command.success(%Join{name: "name"}, self(), world)

    [nest] = world |> World.nests
    message = %{type: :nest, location: nest.pos, food: nest.food, ants: 0, id: nest.id, team: nest.name}

    assert_received {:ok, ^message}
  end

  test "it sends a failure message" do
    Command.failure(%Join{}, self(), %World{})

    assert_received {:error, :name_taken}
  end
end
