
# Import some module from lib that may not yet have been defined
IO.puts "importing Ecto.Query"
import_if_available(Ecto.Query)


IO.puts "Aliasing:"

IO.puts "Ecto.Query"
alias Ecto.Query
IO.puts "Repo"
alias HiveBackend.Repo
IO.puts "User"
alias HiveBackend.Accounts.User
IO.puts "Poems"
alias HiveBackend.Poems.Poem
IO.puts "Themes"
alias HiveBackend.Poems.Theme
