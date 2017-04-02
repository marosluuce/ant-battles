defmodule AntBattles.Commands.Noop do
  defstruct action: :noop, id: -1
end

defimpl AntBattles.Commands.Command, for: AntBattles.Commands.Noop do
  def execute(_, _), do: :ok

  def success(_, _), do: {:ok, :ok}

  def failure(_, _), do: {:error, :error}
end
