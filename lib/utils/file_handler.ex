defmodule AdventOfCode.FileHandler do
  require Logger

  @pages_path Path.expand("input", File.cwd!())

  def handle_file({:ok, contents}) do
    contents
  end

  def handle_file({:error, reason}) do
    Logger.error("File reading error: #{reason}")
  end

  def read_input(file_name) do
    @pages_path
    |> Path.join(file_name)
    |> File.read()
    |> handle_file()
  end
end
