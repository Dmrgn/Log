     /$$        /$$$$$$   /$$$$$$ 
    | $$       /$$__  $$ /$$__  $$
    | $$      | $$  \ $$| $$  \__/
    | $$      | $$  | $$| $$ /$$$$
    | $$      | $$  | $$| $$|_  $$
    | $$      | $$  | $$| $$  \ $$
    | $$$$$$$$|  $$$$$$/|  $$$$$$/
    |________/ \______/  \______/ 
          LANGUAGE OF GODS                              

![meme image](./image.jpg)
# LOG

log is a simple interpreted stack-based programming language written in elixir.

Here is the hello world program:
```log
vpush 'all your codebase are belong to us.'
print
```

Adding:
```log
vpush 9 10
add
print
```

You can run the example programs with
```shell
mix escript.build && ./log examples/helloworld.log
```

## Change LOG

- ### v 0.2.4
  Parser supports the `print` command

- ### v 0.2.3
  Parser supports `add` and `sub` commands for addition and subtraction

- ### v 0.2.2
  Parser can pop a variable number of arguments off a stack

- ### v 0.2.1
  Parser can pop arguments off a stack

- ### v 0.2.0
  Parser can push arguments onto a stack

- ### v 0.1.1
  Lexer can parse string literals

- ### v 0.1.0
  Lexer can parse source code into tokens.
