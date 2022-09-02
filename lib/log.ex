defmodule Log do
  @moduledoc """
  Documentation for `Log` the language of gods.
  """

  # @doc """
  # Hello world.

  # ## Examples

  #     iex> Log.main("test")
  #     ["test"]

  # """

  def main(args) do
    [file | _options] = args
    # read in example file
    IO.puts("Reading file " <> file)
    try do
      file_data = File.read!(file) <> "\n"
      IO.puts("file_data is: " <> file_data)
      result = Lexer.lex([], [], file_data)
      IO.puts("Result of lex is:")
      IO.inspect(result)
    rescue
      e -> IO.inspect(e)
    end
  end
end
