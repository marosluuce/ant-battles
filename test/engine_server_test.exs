defmodule EngineServerTest do
  use ExUnit.Case

  test "a new server is an empty world" do
    {:ok, state} = EngineServer.init(:args)

    assert state == %Engine{}
  end

  test "queues a command" do
    command = %Noop{}
    {:reply, reply, state} =
      EngineServer.handle_call({:me, command}, {self(), :ref}, %Engine{})

    assert reply == {:ok, :enqueued}
    assert state.instructions == [{:me, self(), command}]
  end

  test "only queues one command per user" do
    command_1 = %Noop{}
    command_2 = %Noop{}

    {:reply, _, state} =
      EngineServer.handle_call({:me, command_1}, {self(), :ref}, %Engine{})

    {:reply, error, state} =
      EngineServer.handle_call({:me, command_2}, {self(), :ref}, state)

    assert error == {:error, :already_enqueued}
    assert state.instructions == [{:me, self(), command_1}]
  end

  test "tick clears the command queue" do
    engine = %Engine{instructions: [{:me, self(), %Noop{}}]}
    {:noreply, state} =
      EngineServer.handle_cast(:tick, engine)

    assert Enum.empty?(state.instructions)
  end

  test "known commands succeed" do
    engine = %Engine{instructions: [{:me, self(), %Noop{}}]}
    EngineServer.handle_cast(:tick, engine)

    assert_received {:ok, :ok}
  end

  test "unknown commands error" do
    EngineServer.handle_cast(:tick, %Engine{instructions: [{:me, self(), :unknown}]})

    assert_received {:error, :unknown_command}
  end

  test "tick executes queued commands" do
    initial_world = %World{}
    instruction = {:me, self(), %Register{name: "name"}}
    engine = %Engine{world: initial_world, instructions: [instruction]}

    {:noreply, %Engine{world: updated_world}} = EngineServer.handle_cast(:tick, engine)

    refute initial_world == updated_world
  end
end
