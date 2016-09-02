defmodule Noop do
  defstruct action: :noop, id: -1
end

defimpl Command, for: Noop do
  def execute(_, world), do: {:ok, world}

  def success(_, _), do: {:ok, :ok}

  def failure(_, _), do: {:error, :error}
end
