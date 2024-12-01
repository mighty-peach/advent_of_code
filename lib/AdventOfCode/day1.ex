defmodule AdventOfCode.Day1 do
  alias JasonV.Encode
  require Logger
  import AdventOfCode.FileHandler

  def first_task do
    read_input("1_1.txt")
    |> prepare_data
    |> Enum.map(fn x -> Enum.sort(x) end)
    |> Enum.zip()
    |> Enum.map(fn x ->
      find_distance(elem(x, 0), elem(x, 1))
    end)
    |> Enum.sum()
  end

  def second_task do
    data =
      read_input("1_1.txt")
      |> prepare_data

    quantity =
      Enum.at(data, 1)
      |> Enum.group_by(fn x -> x end)

    Enum.at(data, 0)
    |> Enum.map(fn x ->
      if Map.has_key?(quantity, x) do
        x * length(Map.get(quantity, x))
      else
        0
      end
    end)
    |> Enum.sum()
  end

  defp prepare_data(contents) do
    contents
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn x ->
      String.split(x, "   ")
      |> Enum.map(fn x ->
        case Integer.parse(x) do
          {result, _remainder} -> result
          :error -> Logger.error("Error parsing string: #{x}")
        end
      end)
    end)
    |> List.zip()
    |> Enum.map(fn x -> Tuple.to_list(x) end)
  end

  defp find_distance(x, y) when x > y do
    x - y
  end

  defp find_distance(x, y) when x < y do
    y - x
  end

  defp find_distance(x, y) when x == y do
    0
  end
end
