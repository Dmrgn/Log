defmodule LogTest do
  use ExUnit.Case

  doctest Lexer

  test "Lexes command and number" do
    lexed = Lexer.lex([], [], "vpush 10\n")
    assert lexed === [
      %{type: :command, value: "vpush"},
      %{type: :number, value: "10"},
      :newLine,
    ]
  end

  test "Lexes command and string" do
    lexed = Lexer.lex([], [], "vpush 'test string'\n")
    assert lexed === [
      %{type: :command, value: "vpush"},
      %{type: :string, value: "'test string'"},
      :newLine,
    ]
  end

  test "Lexes multiple commands, strings and numbers" do
    lexed = Lexer.lex([], [], "vpush 'test string'\nvpop\nvpush 10 'another test'\n")
    assert lexed === [
      %{type: :command, value: "vpush"},
      %{type: :string, value: "'test string'"},
      :newLine,
      %{type: :command, value: "vpop"},
      :newLine,
      %{type: :command, value: "vpush"},
      %{type: :number, value: "10"},
      %{type: :string, value: "'another test'"},
      :newLine,
    ]
  end
end
