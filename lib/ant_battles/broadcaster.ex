defmodule AntBattles.Broadcaster do
  use GenServer
  alias AntBattles.Engine

  @name Application.get_env(:ant_battles, :engine)

  def start_link(delay) do
    GenServer.start_link(__MODULE__, delay)
  end

  def init(delay) do
    Process.send_after(self(), :broadcast, delay)
    {:ok, %{delay: delay}}
  end

  def handle_info(:broadcast, state) do
    {:ok, world} = Engine.observe(@name)
    AntBattles.RoomChannel.broadcast(world)

    Process.send_after(self(), :broadcast, state[:delay])

    {:noreply, state}
  end
end
