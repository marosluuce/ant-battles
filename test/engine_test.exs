defmodule EngineTest do
  use ExUnit.Case

  setup do
    Engine.start_link
    :ok
  end

  test "a user joins" do
    assert {:ok, _} = Engine.join(:me, "name")
  end

  test "a user spawns an ant" do
    {:ok, %{id: nest_id}} = Engine.join(:me, "name")
    assert {:ok, _} = Engine.spawn_ant(:me, nest_id)
  end
end
