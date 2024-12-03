defmodule AdventOfCode.Day3 do
  import AdventOfCode.FileHandler

  def first_task() do
    input =
      read_input("3_1.txt")
      |> String.trim()

    Regex.scan(~r{mul\(\d*,\d*\)}, input)
    |> List.flatten()
    |> Enum.map(fn x ->
      String.replace(x, "mul(", "")
      |> String.replace(")", "")
      |> String.split(",")
      |> Enum.map(fn x ->
        case Integer.parse(x) do
          {result, _remainder} -> result
          :error -> Logger.error("Error parsing string: #{x}")
        end
      end)
      |> Enum.product()
    end)
    |> Enum.sum()
  end

  def second_task() do
    input =
      read_input("3_1.txt")
      |> String.trim()

    Regex.scan(~r{(mul\(\d+,\d+\))|(do\()|(don't\()}, input)
    |> Enum.map(&List.first/1)
    |> List.flatten()
    |> calculate
  end

  def calculate(list), do: calculate(list, 0, true)
  def calculate(["do(" | tail], sum, _), do: calculate(tail, sum, true)
  def calculate(["don't(" | tail], sum, _), do: calculate(tail, sum, false)
  def calculate([_head | tail], sum, false), do: calculate(tail, sum, false)
  def calculate([], sum, _), do: sum

  def calculate([head | tail], sum, true) do
    product =
      String.replace(head, "mul(", "")
      |> String.replace(")", "")
      |> String.split(",")
      |> Enum.map(fn x ->
        case Integer.parse(x) do
          {result, _remainder} -> result
          :error -> Logger.error("Error parsing string: #{x}")
        end
      end)
      |> Enum.product()

    calculate(tail, product + sum, true)
  end
end
