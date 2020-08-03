defmodule HiveBackendWeb.StatsView do
  use HiveBackendWeb, :view

  import Ecto.Query
  alias HiveBackend.Poems.Theme
  alias HiveBackend.Repo
  alias HiveBackend.Accounts.User

  def get_user_count do
  	Repo.aggregate(User, :count, :id)
  end
end
