defmodule Util do
  def error(err) do
    IO.puts("\x1B[31mError:\x1B[0m "<>err)
  end

  @doc """
  If the passed string is not parsable
  as a float then return false, otherwise return it as a float

  ## Example
    iex> Util.string_is_float?("1.dda")
    false

    iex> Util.string_is_float?("1.0")
    1.0
  """
  def string_is_float?(string) do
    try do
      {as_float, excess} = Float.parse(string)
      if (String.length(excess) === 0) do
        as_float
      else
        false
      end
    rescue
      _e -> false
    end
  end

  def string_to_list(string) do
    String.split(string, "") |> Enum.slice(1, String.length(string))
  end
end
