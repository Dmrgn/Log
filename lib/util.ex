defmodule Util do
  def error(err) do
    IO.puts(err)
  end

  def string_to_list(string) do
    String.split(string, "") |> Enum.slice(1, String.length(string))
  end
end
