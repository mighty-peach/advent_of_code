defmodule AdventOfCode.Day2 do
  import AdventOfCode.FileHandler

  def first_task do
    result =
      read_input("2_1.txt")
      |> prepare_data
      |> check

    IO.inspect(result)
  end

  def second_task do
    read_input("2_1.txt")
    |> prepare_data
    |> check_with_dampener
  end

  def check([head | tail], sum) do
    if is_safe?(head) do
      check(tail, sum + 1)
    else
      check(tail, sum)
    end
  end

  def check([], sum), do: sum
  def check(list), do: check(list, 0)

  def check_with_dampener([head | tail], sum) do
    safe = is_safe?(head)

    if safe do
      check_with_dampener(tail, sum + 1)
    else
      if Enum.any?(get_variants(head), &is_safe?/1) do
        check_with_dampener(tail, sum + 1)
      else
        check_with_dampener(tail, sum)
      end
    end
  end

  def check_with_dampener([], sum), do: sum
  def check_with_dampener(list), do: check_with_dampener(list, 0)

  def is_safe?(list) do
    all_increasing?(list) || all_decreasing?(list)
  end

  def all_increasing?([x | tail] = list) when length(list) > 1 do
    y = List.first(tail)

    if x < y and y - x <= 3 do
      all_increasing?(tail)
    else
      false
    end
  end

  def all_increasing?(list) when length(list) <= 1, do: true

  def all_decreasing?([x | tail] = list) when length(list) > 1 do
    y = List.first(tail)

    if x > y and x - y <= 3 do
      all_decreasing?(tail)
    else
      false
    end
  end

  def all_decreasing?(list) when length(list) <= 1, do: true

  def prepare_data(data) do
    data
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn x ->
      x
      |> String.trim()
      |> String.split(" ")
      |> Enum.map(fn x ->
        case Integer.parse(x) do
          {result, _remainder} -> result
          :error -> Logger.error("Error parsing string: #{x}")
        end
      end)
    end)
  end

  def get_variants(list) do
    Enum.map(0..(length(list) - 1), fn x ->
      List.delete_at(list, x)
    end)
  end
end
