defmodule Info do
  defstruct id: -1
end

defimpl Command, for: Info do
  def id(%Info{id: id}), do: id

  def execute(%Info{id: id}, world) do
    not_found = world
    |> World.find(id)
    |> is_nil

    if not_found do
      {:error, :invalid_id}
    else
      {:ok, world}
    end
  end

  def success(%Info{id: id}, pid, world) do
    found = world |> World.find(id)

    send pid, {:ok, Message.details(found, world)}
  end

  def failure(_, pid, _) do
    send pid, {:error, :invalid_id}
  end
end
