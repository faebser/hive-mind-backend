defmodule HiveBackendWeb.NewUserController do
  use HiveBackendWeb, :controller

  import Ecto.Query, warn: false
  alias HiveBackend.Accounts


  def new(con, _params) do
  	# return named struct from db
  	start = System.monotonic_time

    status =
    %{active: true, delete: false, user_uuid: Ecto.UUID.generate}
    |> Accounts.create_user

  	# # send to riemann
  	# Riemannx.send_async [
  	# 	service: "today request",
  	# 	metric: System.monotonic_time - start,
  	# 	description: "request duration"
  	# ]

  	case status do
      {:ok, u} -> json con, %{user_id: u.user_uuid}
      {:error, _} ->
        con
        |> put_status(500)
        |> json(%{error: "account creation suspended"})
    end
  end
end