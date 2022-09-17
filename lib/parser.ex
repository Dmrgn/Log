defmodule Parser do

  def get_next_command(lexed) do
    index_of_n = lexed |> Enum.find_index(fn x ->
      x === :newLine
    end)

    if index_of_n === nil do
      {lexed, []}
    else
      command = Enum.slice(lexed, 0, index_of_n)
      remaining = Enum.slice(lexed, index_of_n + 1, length(lexed)-1)
      {command, remaining}
    end
  end

  def pop_stack(stack, args, command_num_string) do
    # IO.inspect(args[])
    stack_length = length(stack)
    if stack_length === 0 do
      Util.error("attempted to pop empty stack on line " <> command_num_string <> ".")
    end
    if length(args) > 1 do
      Util.error("pop expected 0 or 1 arguments on line " <> command_num_string <> " but got " <> Integer.to_string(length(args)) <> " instead.")
    end
    if length(args) === 1 do
      amount_to_pop = Util.string_is_float?(Enum.at(args, 0)[:value]) |> trunc
      if is_boolean(amount_to_pop) do
        Util.error("pop expected a number argument on line " <> command_num_string <> " but got " <> Enum.at(args, 0)[:value] <> " instead.")
      else
        if stack_length < amount_to_pop do
          Util.error("pop attempted to pop " <> Integer.to_string(amount_to_pop) <> " items on line " <> command_num_string <> " but stack had length " <> Integer.to_string(stack_length))
        end
        Enum.slice(stack, 0, stack_length-amount_to_pop)
      end
    else
      if length(stack) === 1 do
        []
      else
        Enum.slice(stack, 0, stack_length-2)
      end
    end
  end

  def contains_command(args) do
    commands = Enum.filter(args, fn element ->
      element[:type] === :command
    end)
    cond do
      length(commands) === 0 ->
        :none
      length(commands) === length(args) ->
        :all
      length(commands) > 0 ->
        :some
    end
  end

  def run_command(vstack, istack, raw, command_num) do
    [command | args] = raw
    command_num_string = Integer.to_string(command_num)
    # IO.puts("==========")
    # IO.inspect(vstack)
    # IO.inspect(istack)
    case command do
      %{type: :command, value: "vpush"} ->
        # ensure no arguments are of type :command
        command_presence = contains_command(args)
        if command_presence == :some or command_presence == :all do
          Util.error("vpush attempted to push an argument of type :command onto the stack on line " <> command_num_string <> " but the vstack can only contain arguments of type :string or :number.")
        end
        {vstack ++ args, istack}
      %{type: :command, value: "ipush"} ->
        # ensure all arguments are of type :command
        if not (contains_command(args) == :all) do
          Util.error("ipush attempted to push an argument which was not of type :command onto the stack on line " <> command_num_string <> " but the istack can only contain arguments of type :command.")
        end
        {vstack, istack ++ args}
      %{type: :command, value: "vpop"} ->
        {pop_stack(vstack, args, command_num_string), istack}
      %{type: :command, value: "ipop"} ->
        {vstack, pop_stack(istack, args, command_num_string)}
      %{type: :command, value: "add"} ->
        if length(vstack) < 2 do
          Util.error("add attempted to operate on a vstack with length " <> Integer.to_string(length(vstack)) <> " but it requires the vstack to have a length greater than or equal to 2.")
        end
        new_vstack = if length(vstack) === 2 do
          []
        else
          Enum.slice(vstack, 0, length(vstack)-2)
        end
        operands = Enum.slice(vstack, length(vstack)-2, length(vstack))
        sum = String.to_integer(Enum.at(operands, 0)[:value]) + String.to_integer(Enum.at(operands, 1)[:value])
        {new_vstack ++ [%{type: :number, value: Integer.to_string(sum)}], istack}
      %{type: :command, value: "sub"} ->
        if length(vstack) < 2 do
          Util.error("sub attempted to operate on a vstack with length " <> Integer.to_string(length(vstack)) <> " but it requires the vstack to have a length greater than or equal to 2.")
        end
        new_vstack = if length(vstack) === 2 do
          []
        else
          Enum.slice(vstack, 0, length(vstack)-2)
        end
        operands = Enum.slice(vstack, length(vstack)-2, length(vstack))
        diff = String.to_integer(Enum.at(operands, 0)[:value]) - String.to_integer(Enum.at(operands, 1)[:value])
        {new_vstack ++ [%{type: :number, value: Integer.to_string(diff)}], istack}
      %{type: :command, value: "print"} ->
        if length(vstack) === 0 do
          Util.error("print attempted to operate on a vstack with length " <> Integer.to_string(length(vstack)) <> " but it requires the vstack to have a length greater than or equal to 1.")
        end
        IO.inspect(Enum.at(vstack, length(vstack)-1)[:value])
        {vstack, istack}
    end
  end

  def parse(vstack, istack, lexed, command_num) do
    if length(lexed) > 0 do
      {command, remaining} = get_next_command(lexed)
      {new_vstack, new_istack} = run_command(vstack, istack, command, command_num)
      parse(new_vstack, new_istack, remaining, command_num+1)
    else
      0
    end
  end
end
