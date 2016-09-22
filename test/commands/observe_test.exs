defmodule ObserveTest do
  use ExUnit.Case, async: true

  alias AntBattles.World
  alias AntBattles.Commands.Command
  alias AntBattles.Commands.Observe

  test "execute always succeeds" do
    assert {:ok, :world} = Command.execute(%Observe{}, :world)
  end

  test "success sends a message" do
    assert {:ok, %{ants: [], food: [], nests: []}} = Command.success(%Observe{}, %World{})
  end

  test "failure sends a message" do
    assert {:error, :failed_to_observe} = Command.failure(%Observe{}, %World{})
  end
end
