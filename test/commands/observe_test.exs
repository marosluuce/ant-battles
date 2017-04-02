defmodule ObserveTest do
  use ExUnit.Case, async: true

  alias AntBattles.Commands.Command
  alias AntBattles.Commands.Observe

  setup do
    [name: AntBattles.WorldHelper.create()]
  end

  test "execute always succeeds", context do
    assert :ok = Command.execute(%Observe{}, context[:name])
  end

  test "success sends a message", context do
    assert {:ok, %{ants: [], food: [], nests: []}} = Command.success(%Observe{}, context[:name])
  end

  test "failure sends a message", context do
    assert {:error, :failed_to_observe} = Command.failure(%Observe{}, context[:name])
  end
end
