defmodule Identicon do
  @moduledoc """
  Documentation for `Identicon`.

  # Steps
    - Input string
    - Compute MD5 hash
    - List of numbers based on the string
    - Pick color(first 3 digits of the array)
    - Build grid of squares (assign the rest in the grid5x5, then color even numbers in the grid)
    - Convert grid into image
    - Save image
  """

  def main(input) do
    input
    |> hash_input()
    |> pick_color()
    |> build_grid()
    |> filter_odd_squares()
  end

  def hash_input(input) do
    hex =
      :crypto.hash(:md5, input)
      |> :binary.bin_to_list()

    %Identicon.Image{hex: hex}
  end

  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    # %Identicon.Image{hex: [r, g, b | _tail]} = image
    %Identicon.Image{(%Identicon.Image{} = image) | color: {r, g, b}}
  end

  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid =
      hex
      |> Enum.chunk_every(3, 3, :discard)
      |> Enum.map(&mirrow_row/1)
      |> List.flatten()
      |> Enum.with_index()

    %Identicon.Image{image | grid: grid}
  end

  def mirrow_row(row) do
    # 1, 2, 3
    [first, second | _tail] = row

    # 1, 2, 3, 2, 1
    row ++ [second, first]
  end

  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    grid =
      Enum.filter(grid, fn {code, _index} ->
        rem(code, 2) == 0
      end)

    %Identicon.Image{image | grid: grid}
  end
end
