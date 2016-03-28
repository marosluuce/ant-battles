defmodule Noop do
  defstruct action: :noop
end

defimpl Command, for: Noop do
  def execute(_, world), do: {:ok, world}

  def success(_, pid, _), do: send pid, {:ok, :ok}

  def failure(_, pid, _), do: send pid, {:error, :error}
end
