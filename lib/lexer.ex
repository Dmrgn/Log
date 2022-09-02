# contains functions for turning source code into
# computer readable, generalized tokens
defmodule Lexer do

  # creates a subsection string of 'mess' which includes
  # every element until the first appearance of 'stopper'
  # returns the subsection as a string as well as the
  # remaining elements in 'mess'
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

  # if the passed string representation of a token is not parsable
  # as a float then return false, otherwise return it as a float
  def token_is_float?(token) do
    try do
      {as_float, excess} = Float.parse(token)
      if (String.length(excess) === 0) do
        as_float
      else
        false
      end
    rescue
      _e -> false
    end
  end

  # returns the type of the passed string representation
  # of a token (:string, :number or :command)
  def type_of_token(token) do
    cond do
      # :strings start and end with '
      String.starts_with?(token, "'") && String.ends_with?(token, "'") ->
        :string
      # :numbers contain only 0-9 or .
      token_is_float?(token) ->
        :number
      # :commands contain anything else
      true ->
        :command
    end
  end

  # recursively converts the passed string 'raw' into lexed tokens
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
            Util.error("Error, failed to consume item from stack.")
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
