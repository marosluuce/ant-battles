defmodule Info do
  defstruct id: -1
end

defimpl Command, for: Info do
  def execute(%Info{id: id}, world) do
    ants = world |> World.ants
    nests = world |> World.nests

    not_found = ants ++ nests
    |> Enum.find(&(&1.id == id))
    |> is_nil

    if not_found do
      {:error, :invalid_id}
    else
      {:ok, world}
    end
  end

  def success(%Info{id: id}, pid, world) do
    ants = world |> World.ants
    nests = world |> World.nests

    found = ants ++ nests
    |> Enum.find(&(&1.id == id))

    send pid, {:ok, Message.details(found, world)}
  end

  def failure(_, pid, _) do
    send pid, {:error, :invalid_id}
  end
end
