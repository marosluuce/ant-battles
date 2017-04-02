defmodule AntBattles.Id do

  def random do
    System.system_time |> to_string
  end
end
