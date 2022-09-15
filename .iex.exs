# --------------------------------------------------
# Import Global configuration
# --------------------------------------------------
File.exists?(Path.expand("~/.iex.exs")) && import_file("~/.iex.exs")

# --------------------------------------------------
# Debug breakpoints
# --------------------------------------------------

# In code (https://hexdocs.pm/iex/IEx.html#pry/0)
#
# ```
# require IEx; IEx.pry()
# ```

# For a specific function (https://hexdocs.pm/iex/IEx.html#break!/4)
#
# ```
# IEx.break!(module, function, arity, stops \\ 1)
# ```

# --------------------------------------------------
# Project Aliases
# --------------------------------------------------
alias Archer
