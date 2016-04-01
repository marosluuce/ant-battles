defmodule EngineTest do
  use ExUnit.Case, async: true

  setup do
    Engine.start_link(1)
    :ok
  end

  test "a user joins" do
    assert {:ok, _} = Engine.join(:me, "name")
  end

  test "a user spawns an ant" do
    {:ok, %{id: nest_id}} = Engine.join(:me, "name")
    assert {:ok, _} = Engine.spawn_ant(:me, nest_id)
  end

  test "a user moves an ant" do
    {:ok, %{id: nest_id}} = Engine.join(:me, "name")
    {:ok, %{id: ant_id}} = Engine.spawn_ant(:me, nest_id)
    assert {:ok, _} = Engine.move_ant(:me, ant_id, "n")
  end
end
