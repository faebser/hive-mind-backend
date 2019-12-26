defmodule HiveBackendWeb.PoemSubmitController do
  use HiveBackendWeb, :controller

  import Ecto.Query, warn: false
  alias HiveBackend.Repo
  alias HiveBackend.TodayRequest
  alias HiveBackend.Poems.Theme
  alias HiveBackend.Poems.Poem

  alias HiveBackend.Accounts.User

  plug HiveBackendWeb.Plugs.CheckParams, fields: ["user_id", "content"]


  def submit(con, params) do
  	# add poem to database
  	start = System.monotonic_time

  	u = User |> Repo.get_by( user_uuid: params["user_id"] )
  	t = Theme |> Repo.get_by( date_for: Date.utc_today )

  	poem = %Poem{content: params["content"], date_for: t.date_for, user_id: u.id}

  	status = 
  	poem 
  	|> Poem.changeset(%{})
  	|> Repo.insert


  	# send to riemann
  	# Riemannx.send_async [
  	# 	service: "submit request",
  	# 	metric: System.monotonic_time - start,
  	# 	description: "request duration"
  	# ]

  	case status do
  		{:ok, _} -> json con, %{inserted: true}
  		{:error, changeset} ->
  			con
  			|> put_status(500)
  			|> json(changeset.errors)
  	end
  end
end