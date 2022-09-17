defmodule Lexer do
  @moduledoc """
  Parser for `LOG` language of gods.
  Contains functions for turning source code into
  computer readable, generalized tokens
  """

  @doc """
  Creates a subsection string of 'mess' which includes
  every element until the first appearance of 'stopper'

  Returns the subsection as a string as well as the
  remaining elements in 'mess'

  ## Example
    iex> Lexer.scan_until(["m","y"," ","d","a","n","i","e","l"], "d")
    {" ym", ["a","n","i","e","l"]}
  """
  def scan_until(mess, stopper) do
    index_of_break = mess |> Enum.find_index(fn x ->
      x === stopper
    end)

    consumed = mess |> Enum.reduce_while("", fn element, acc ->
      if element !== stopper, do: {:cont, acc <> element}, else: {:halt, acc}
    end) |> String.reverse()

    {consumed, if (index_of_break == nil) do
      []
    else
      Enum.slice(mess, index_of_break + 1, length(mess) - 1)
    end}
  end

  @doc """
  Returns the type of the passed string representation
  of a token (:string, :number or :command)

  ## Example
    iex> Lexer.type_of_token("'this is a string'")
    :string
  """
  def type_of_token(token) do
    cond do
      # :strings start and end with '
      String.starts_with?(token, "'") && String.ends_with?(token, "'") ->
        :string
      # :numbers contain only 0-9 or .
      Util.string_is_float?(token) ->
        :number
      # :commands contain anything else
      true ->
        :command
    end
  end

  @doc """
  Recursively converts the passed string 'raw' into lexed tokens

  ## Example
    iex> IO.inspect(Lexer.lex([],[],"vpush "))
    [%{type: :command, value: "vpush"}]
  """
  def lex(lexed, stack, raw) do
    if String.length(raw) > 0 do
      cur_char = raw |> String.first()
      cond do
        # token separator
        cur_char === " " or cur_char === "\n" ->
          {consumed, new_stack} = scan_until(Enum.reverse(stack), :break)
          remaining_chars = String.slice(raw, 1, String.length(raw)-1)

          # check if there was nothing on the stack to consume
          if String.length(consumed) === 0 do
            Util.error("failed to consume item from stack.")
          end

          # push the stack onto lexed
          new_lexed_element = %{:type => type_of_token(consumed), :value => consumed}

          if (cur_char === "\n") do
            lex(lexed ++ [new_lexed_element, :newLine], new_stack, remaining_chars)
          else
            lex(lexed ++ [new_lexed_element], new_stack, remaining_chars)
          end
        # token for start of string
        cur_char === "'" ->
          {consumed, remaining_chars} = scan_until(Util.string_to_list(String.slice(raw, 1, String.length(raw)-1)), "'")
          lex(lexed, stack ++ ["'"<>consumed<>"'"], Enum.join(remaining_chars, ""))
        # token for anything else (command, number)
        true ->
          remaining_chars = String.slice(raw, 1, String.length(raw)-1)
          lex(lexed, stack ++ [cur_char], remaining_chars)
      end

    else
      lexed
    end
  end
end
