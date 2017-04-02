defmodule AntBattles.Commands.Look do
  defstruct ant_id: -1
end

defimpl AntBattles.Commands.Command, for: AntBattles.Commands.Look do
  alias AntBattles.Stores
  alias AntBattles.Message

  def execute(command, name) do
    not_found = Stores.Ants.get(name, command.ant_id)
    |> is_nil

    if not_found do
      :error
    else
      :ok
    end
  end

  def success(command, name) do
    message = name
    |> Stores.Ants.get(command.ant_id)
    |> Message.with_surroundings(name)

    {:ok, message}
  end

  def failure(_, _) do
    {:error, :invalid_id}
  end
end
