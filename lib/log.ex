defmodule Log do
  @moduledoc """
  Documentation for `LOG` language of gods.
  """

  @doc """
  Runs a LOG program passed from the command line as a file.
  """

  # ## Examples

  #     iex> Log.main("test")
  #     ["test"]


  def main(args) do
    [file | _options] = args

    try do
      file_data = File.read!(file) <> "\n"
      # IO.puts("file_data is: " <> file_data)
      lexed = Lexer.lex([], [], file_data)
      # IO.puts("Result of lex is:")
      # IO.inspect(lexed)
      parsed = Parser.parse([], [], lexed, 1);
      # IO.puts("Result of parse is:")
      # IO.inspect(parsed)
    rescue
      e -> IO.inspect(e)
    end
  end
end
