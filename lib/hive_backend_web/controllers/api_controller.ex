defmodule HiveBackendWeb.ApiController do
  use HiveBackendWeb, :controller

  import Ecto.Query, warn: false
  alias HiveBackend.Repo
  alias HiveBackend.TodayRequest
  alias HiveBackend.Poems.Theme

  alias HiveBackend.Accounts.User

  def today(con, _params) do
  	# return named struct from db
  	start = System.monotonic_time

  	t = Theme |> Repo.get_by(date_for: Date.utc_today)
  	
  	j = case t do
  		nil -> %TodayRequest{theme_content: "not found", date_for: nil, theme_id: nil } # TODO return a 404 not found
  		_ ->  %TodayRequest{theme_content: t.content, date_for: t.date_for, theme_id: t.id}
  	end

  	# # send to riemann
  	# Riemannx.send_async [
  	# 	service: "today request",
  	# 	metric: System.monotonic_time - start,
  	# 	description: "request duration"
  	# ]

  	# return something here
  	json con, j
  end

  
end