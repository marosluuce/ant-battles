defmodule EngineTest do
  use ExUnit.Case, async: true

  setup do
    Engine.start_link(1)
    :ok
  end

  test "a user joins" do
    assert {:ok, %{}} = Engine.join(:me, "name")
  end

  test "a user spawns an ant" do
    {:ok, %{id: nest_id}} = Engine.join(:me, "name")
    assert {:ok, %{}} = Engine.spawn_ant(:me, nest_id)
  end

  test "a user moves an ant" do
    {:ok, %{id: nest_id}} = Engine.join(:me, "name")
    {:ok, %{id: ant_id}} = Engine.spawn_ant(:me, nest_id)
    assert {:ok, %{}} = Engine.move_ant(:me, ant_id, "n")
  end

  test "a user can look with an ant" do
    {:ok, %{id: nest_id}} = Engine.join(:me, "name")
    {:ok, %{id: ant_id}} = Engine.spawn_ant(:me, nest_id)
    assert {:ok, %{}} = Engine.look(:me, ant_id)
  end

  test "a user can get info" do
    {:ok, %{id: nest_id}} = Engine.join(:me, "name")
    assert {:ok, %{}} = Engine.info(:me, nest_id)
  end
end
