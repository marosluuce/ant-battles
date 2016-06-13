defmodule ObserveTest do
  use ExUnit.Case, async: true

  test "execute always succeeds" do
    assert {:ok, :world} = Command.execute(%Observe{}, :world)
  end

  test "success sends a message" do
    Command.success(%Observe{}, self(), %World{})

    assert_received {:ok, %{ants: [], food: [], nests: []}}
  end

  test "failure sends a message" do
    Command.failure(%Observe{}, self(), %World{})

    assert_received {:error, :failed_to_observe}
  end
end
