defmodule AntBattles.RoomChannel do
  use Phoenix.Channel

  def join("room:admin", _message, socket) do
    {:ok, socket}
  end

  def join(_, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def broadcast(payload) do
    AntBattles.Endpoint.broadcast!("room:admin", "world:update", payload)
  end
end
