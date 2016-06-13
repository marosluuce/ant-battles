defmodule EngineTest do
  use ExUnit.Case

  setup do
    Engine.start_link(delay: 1)
    :ok
  end

  test "a user joins" do
    assert {:ok, %{team: "name"}} = Engine.join("name")
  end

  test "a user spawns an ant" do
    {:ok, %{id: nest_id}} = Engine.join("name")
    assert {:ok, %{nest: ^nest_id}} = Engine.spawn_ant(nest_id)
  end

  test "a user moves an ant" do
    {:ok, %{id: nest_id}} = Engine.join("name")
    {:ok, %{id: ant_id}} = Engine.spawn_ant(nest_id)
    assert {:ok, %{id: ^ant_id}} = Engine.move_ant(ant_id, "n")
  end

  test "a user can look with an ant" do
    {:ok, %{id: nest_id}} = Engine.join("name")
    {:ok, %{id: ant_id}} = Engine.spawn_ant(nest_id)
    assert {:ok, %{id: ^ant_id}} = Engine.look(ant_id)
  end

  test "a user can get info" do
    {:ok, %{id: nest_id}} = Engine.join("name")
    assert {:ok, %{id: ^nest_id}} = Engine.info(nest_id)
  end

  test "a user can add food" do
    assert {:ok, :added_food} = Engine.add_food({0, 0}, 1)
  end
end
