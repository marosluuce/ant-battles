defmodule EngineTest do
  use ExUnit.Case, async: true

  alias AntBattles.Commands.Noop

  alias AntBattles.Engine
  alias AntBattles.Stores

  setup do
    name = System.system_time |> to_string
    Engine.start_link(name)
    Stores.Ants.start_link(name)
    Stores.Food.start_link(name, 0, 0)
    Stores.Nests.start_link(name)

    {:ok, [name: name]}
  end

  def random_name do
    System.system_time() |> to_string
  end

  test "a user joins", context do
    team = random_name()
    assert {:ok, %{team: ^team}} = Engine.join(context[:name], team)
  end

  test "a user spawns an ant", context do
    {:ok, %{id: nest_id}} = Engine.join(context[:name], "name")
    assert {:ok, %{nest: ^nest_id}} = Engine.spawn_ant(context[:name], nest_id)
  end

  test "a user moves an ant", context do
    {:ok, %{id: nest_id}} = Engine.join(context[:name], "name")
    {:ok, %{id: ant_id}} = Engine.spawn_ant(context[:name], nest_id)
    assert {:ok, %{id: ^ant_id}} = Engine.move_ant(context[:name], ant_id, "n")
  end

  test "a user can look with an ant", context do
    {:ok, %{id: nest_id}} = Engine.join(context[:name], "name")
    {:ok, %{id: ant_id}} = Engine.spawn_ant(context[:name], nest_id)
    assert {:ok, %{id: ^ant_id}} = Engine.look(context[:name], ant_id)
  end

  test "a user can get info", context do
    {:ok, %{id: nest_id}} = Engine.join(context[:name], "name")
    assert {:ok, %{id: ^nest_id}} = Engine.info(context[:name], nest_id)
  end

  test "a user can add food", context do
    assert {:ok, :added_food} = Engine.add_food(context[:name], {0, 0}, 1)
  end

  test "a new server is an empty world" do
    assert {:ok, "name"} == Engine.init("name")
  end

  test "gets current world" do
    assert {:reply, "name", "name"} ==
      Engine.handle_call(:get_world, {self(), :ref}, "name")
  end

  test "known commands succeed" do
    assert {:reply, {:ok, _}, _} = Engine.handle_call({:run, %Noop{}}, {}, :world)
  end

  test "unknown commands error" do
    assert {:reply, {:error, _}, _} = Engine.handle_call({:run, :unknown}, {}, :world)
  end
end
