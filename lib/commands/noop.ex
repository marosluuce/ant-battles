defmodule Noop do
  defstruct action: :noop, id: -1
end

defimpl Command, for: Noop do
  def id(%Noop{id: id}), do: id

  def execute(_, world), do: {:ok, world}

  def success(_, pid, _), do: send pid, {:ok, :ok}

  def failure(_, pid, _), do: send pid, {:error, :error}
end
