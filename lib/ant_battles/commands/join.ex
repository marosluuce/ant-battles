defmodule AntBattles.Commands.Join do
  defstruct team: ""
end

defimpl AntBattles.Commands.Command, for: AntBattles.Commands.Join do
  alias AntBattles.World
  alias AntBattles.Stores
  alias AntBattles.Message

  def execute(command, name) do
    if Stores.Nests.registered?(name, command.team) do
      :error
    else
      Stores.Nests.register(name, World.new_nest(command.team))
      :ok
    end
  end

  def success(command, name) do
    {:ok, Message.details(Stores.Nests.find_by_name(name, command.team))}
  end

  def failure(_, _), do: {:error, :name_taken}
end
