defmodule AdventOfCode.Day2 do
  import AdventOfCode.FileHandler

  @moduledoc """
  Only first_task is correct ;(
  """

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

    # IO.inspect(check_with_dampener([[4, 3, 1, 2]]))
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
    safe = is_safe_tolerated?(head)

    IO.puts("#{inspect(head, charlists: :as_lists)} - #{is_safe_tolerated?(head)}")

    if safe do
      check_with_dampener(tail, sum + 1)
    else
      check_with_dampener(tail, sum)
    end
  end

  def check_with_dampener([], sum), do: sum
  def check_with_dampener(list), do: check_with_dampener(list, 0)

  def is_safe_tolerated?(list) do
    all_increasing_tolerated?(list) || all_decreasing_tolerated?(list)
  end

  def all_decreasing_tolerated?([x | tail] = list, is_dampener_used) when length(list) > 1 do
    [y | t] = tail

    z =
      if is_list(t) do
        List.first(t, nil)
      else
        nil
      end

    cond do
      decreasing(x, y) -> all_decreasing_tolerated?(tail, is_dampener_used)
      !is_dampener_used and is_nil(z) -> true
      is_nil(z) -> false
      decreasing(x, z) and !is_dampener_used -> all_decreasing_tolerated?(t, true)
      decreasing(y, z) and !is_dampener_used -> all_decreasing_tolerated?(t, true)
      true -> false
    end
  end

  def all_decreasing_tolerated?(list, _) when length(list) <= 1, do: true
  def all_decreasing_tolerated?(list), do: all_decreasing_tolerated?(list, false)

  def all_increasing_tolerated?([x | tail] = list, is_dampener_used) when length(list) > 1 do
    [y | t] = tail

    z =
      if is_list(t) do
        List.first(t, nil)
      else
        nil
      end

    cond do
      increasing(x, y) -> all_increasing_tolerated?(tail, is_dampener_used)
      !is_dampener_used and is_nil(z) -> true
      is_nil(z) -> false
      increasing(x, z) and !is_dampener_used -> all_increasing_tolerated?(t, true)
      increasing(y, z) and !is_dampener_used -> all_increasing_tolerated?(t, true)
      true -> false
    end
  end

  def all_increasing_tolerated?(list, _) when length(list) <= 1, do: true
  def all_increasing_tolerated?(list), do: all_increasing_tolerated?(list, false)

  def is_safe?(list) do
    all_increasing?(list) || all_decreasing?(list)
  end

  def all_increasing?([x | tail] = list) when length(list) > 1 do
    y = List.first(tail)

    if increasing(x, y) <= 3 do
      all_increasing?(tail)
    else
      false
    end
  end

  def all_increasing?(list) when length(list) <= 1, do: true

  def all_decreasing?([x | tail] = list) when length(list) > 1 do
    y = List.first(tail)

    if decreasing(x, y) <= 3 do
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

  def decreasing(x, y) do
    x > y and x - y <= 3
  end

  def increasing(x, y) do
    x < y and y - x <= 3
  end
end
