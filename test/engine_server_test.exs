defmodule EngineServerTest do
  use ExUnit.Case

  test "a new server is an empty world" do
    {:ok, state} = EngineServer.init(:args)

    assert state == %Engine{}
  end

  test "queues a command" do
    command = %Register{name: "name"}
    {:reply, reply, state} =
      EngineServer.handle_call({:me, command}, {self(), :ref}, %Engine{})

    assert reply == {:ok, :enqueued}
    assert state.commands == [{:me, self(), command}]
  end

  test "only queues one command per user" do
    command_1 = %Register{name: "name"}
    command_2 = %Register{name: "something"}

    {:reply, _, state} =
      EngineServer.handle_call({:me, command_1}, {self(), :ref}, %Engine{})

    {:reply, error, state} =
      EngineServer.handle_call({:me, command_2}, {self(), :ref}, state)

    assert error == {:error, :already_enqueued}
    assert state.commands == [{:me, self(), command_1}]
  end

  test "tick clears the command queue" do
    {:noreply, state} =
      EngineServer.handle_cast(:tick, %Engine{commands: [{:me, self(), :command}]})

    assert state.commands |> Enum.empty?
  end

  test "unknown commands do nothing" do
    EngineServer.handle_cast(:tick, %Engine{commands: [{:me, self(), :command}]})

    assert_received {:error, :unknown_command}
  end

  test "tick executes queued commands" do
    engine = %Engine{commands: [{:me, self(), %Register{name: "name"}}]}
    {:noreply, new_engine} = EngineServer.handle_cast(:tick, engine)

    assert new_engine.world.nests == [%Nest{name: "name"}]
  end

  test "joining sends nest details" do
    engine = %Engine{commands: [{:me, self(), %Register{name: "name"}}]}
    {:noreply, state} = EngineServer.handle_cast(:tick, engine)

    [nest] = state.world.nests
    message = %{position: nest.pos, food: nest.food, id: nest.id}

    assert_received {:ok, message}
  end

  test "moving an ant sends details" do
    world = %World{ants: [%Ant{id: 1, pos: {2, 3}}]}
    command = %Move{ant_id: 1, direction: {0, 1}}
    engine = %Engine{commands: [{:me, self(), command}], world: world}

    EngineServer.handle_cast(:tick, engine)

    assert_received {:ok, "Ant-1 now at (2, 4)"}
  end
end
