defprotocol Command do
  @fallback_to_any true

  def execute(command, world)
  def success(command, world)
  def failure(command, world)
end

defimpl Command, for: Any do
  def execute(_, world), do: world

  def success(_, _), do: {:error, :unknown_command}

  def failure(_, _), do: {:error, :unknown_command}
end
