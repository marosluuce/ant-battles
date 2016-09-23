defmodule AntBattles.Location do
  def random(radius) do
    x = :rand.uniform(radius) - radius / 2
    y = :rand.uniform(radius) - radius / 2

    case {x, y} do
      {0, 0} -> random(radius)
      coordinate -> coordinate
    end
  end
end
