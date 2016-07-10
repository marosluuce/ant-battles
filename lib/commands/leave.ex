defmodule Leave do
  defstruct nest_id: -1
end

defimpl Command, for: Leave do
  def id(%Leave{nest_id: nest_id}), do: nest_id

  def execute(%Leave{nest_id: nest_id}, world) do
    World.unregister(world, nest_id)
  end

  def success(%Leave{nest_id: nest_id}, pid, world) do
    send pid, {:ok, %{:removed => nest_id}}
  end
  def failure(_, pid, _), do: {:error, :item_does_not_exist}
end
