defmodule HiveBackendWeb.ThemeView do
  use HiveBackendWeb, :view

  	import Ecto.Query
  	alias HiveBackend.Poems.Theme
  	alias HiveBackend.Repo

  	def get_date_of_last_theme do
  		Theme |> last(:date_for) |> Repo.one |> Map.get(:date_for)
  		#t.date_for
  	end
end
