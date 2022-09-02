defmodule M do
  def main do
    name = IO.gets("What is your name? ")
    name |> String.trim() |> IO.puts()

    # shift + 3 for auto wrap in brackets
    IO.puts "#{:Pittsburgh}"

    # use double quotes for spaces in atoms
    IO.puts :"Test Thing"

    # prefix unused variables with an underscore
    _one_to_10 = 1..10

    # concat strings with <>
    # remove the trailing \n of name with String.slice
    ((name |> String.slice((0..(String.length(name)-2)))) <> " is my name") |> IO.puts()

    ("egg" === "Egg") |> IO.puts()

    # String.contains?
    # methods which are boolean end with ?
    IO.puts("eggs" |> String.contains?("gg"))
  end

  def main2 do
    # IO.inspect to print non-string/numerical data in a formated way
    IO.gets("Enter a string: ") |> String.split(" ") |> IO.inspect()

    # rem is the remainder function
    IO.puts("#{-4 |> rem(5)}")

    # integer division
    IO.puts("#{div(9,5)}")

    # floating point division
    IO.puts("#{9/5}")

    # == is equality of value
    # === is equality of value and type
  end

  def test_name do
    name = IO.gets("What is your name? ")
    unless name === "Daniel\n" do
      IO.puts("Hmmm... I don't trust you!")
    else
      IO.puts("all your codebase are belong to us.")
    end
  end

  def test_age do
    input = IO.gets("Enter your age pls:")
    age = ((input |> String.slice((0..(String.length(input)-2))))|> String.to_integer())

    test = cond do
      age > 100 ->
        "You are lying"
      age > 50 ->
        "You are old"
      age > 25 ->
        "Still young"
      true -> "toddler"
    end

    test |> IO.puts()
  end

  def ageism do
    # terinary
    IO.puts(if "Daniel" === "Daniel", do: "yes", else: "no")

    # tuples
    thingy = {10,"hello",1..10}

    # pattern matching
    {number, hello, range} = thingy
    number |> IO.puts()
    hello |> IO.puts()
    range |> IO.inspect()

    list = [1,10,9,"hello"]
    list2 = [5,1..10,"nope"]

    # concat lists
    combined_list = list ++ list2
    combined_list |> IO.inspect()

    # subtract lists
    list_test = [1,2,3,4,5]
    list_test2 = [2,4]
    list_test -- list_test2 |> IO.inspect() # prints [1, 3, 5]

    # check if an item is in a list (happy python noises)
    IO.puts(2 in list_test)

    [head | tail] = list_test
    IO.puts("head #{head}")
    IO.inspect(tail)

    # writes without a new line
    IO.write("hello")
  end

  def iteration do
    list = [1,2,3,4]
    [_ | tail] = list
    Enum.each tail, fn item ->
      IO.write(Integer.to_string(item) <> " ")
    end
    IO.write("\n")

    # dictionaries (also just lists)
    stats = [name: "Daniel", age: 15, legendary?: true]
    Enum.each stats, fn stat ->
      IO.inspect(stat)
    end

    IO.puts(stats[:name])
  end

  def functions do
    # anonymous functions
    anon = fn (x, y) -> x+y end
    # anonymous functions shorthand
    anon_but_better = &(&1 + &2)

    # use . to access anonymous function from variable
    IO.puts(anon.(1,1))
    IO.puts anon_but_better.(1,10)

    # different number of params for a function
    fun = fn
      {x,y} -> x+y
      {x,y,z} -> x+y+z
    end

    IO.puts(fun.({10,10}))
    IO.puts(fun.({10,10,20}))

    IO.puts("looping 10-0 inclusive:")
    loop(10,1)
  end

  # use recursion for looping
  def loop(i, dec) do
    IO.puts(i)
    if i > 0 do
      loop(i - dec, dec)
    end
  end
end

M.functions()
