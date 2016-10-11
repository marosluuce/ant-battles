defmodule AntBattles.Location do
  def random(radius) do
    x = trunc(:rand.uniform(radius) - radius / 2)
    y = trunc(:rand.uniform(radius) - radius / 2)

    {x, y}
  end
end
