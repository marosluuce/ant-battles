defprotocol AntBattles.Commands.Command do
  @fallback_to_any true

  def execute(command, world)
  def success(command, world)
  def failure(command, world)
end

defimpl AntBattles.Commands.Command, for: Any do
  def execute(_, _), do: :error

  def success(_, _), do: {:error, :unknown_command}

  def failure(_, _), do: {:error, :unknown_command}
end
