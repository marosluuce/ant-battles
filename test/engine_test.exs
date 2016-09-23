defmodule EngineTest do
  use ExUnit.Case

  alias AntBattles.World
  alias AntBattles.Commands.Noop

  alias AntBattles.Engine

  setup do
    Engine.reset()
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

  test "a new server is an empty world" do
    {:ok, state} = Engine.init(%World{})

    assert state == %World{}
  end

  test "gets current world" do
    assert {:reply, %World{}, %World{}} ==
      Engine.handle_call(:get_world, {self(), :ref}, %World{})
  end

  test "known commands succeed" do
    assert {:reply, {:ok, :ok}, _} = Engine.handle_call({:run, %Noop{}}, {}, :world)
  end

  test "unknown commands error" do
    assert {:reply, {:error, :unknown_command}, _} = Engine.handle_call({:run, :unknown}, {}, :world)
  end
end
