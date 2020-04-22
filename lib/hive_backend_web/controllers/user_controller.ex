defmodule HiveBackendWeb.UserController do
  use HiveBackendWeb, :controller


  import Ecto.Query
  alias Ecto.Query
  alias Ecto.UUID

  alias HiveBackend.Repo
  alias HiveBackend.Accounts
  alias HiveBackend.Accounts.User
  alias HiveBackend.Poems.Poem

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.user_path(conn, :index))
  end

  def get_poems(conn, %{"uuid" => uuid}) do
    case UUID.cast(uuid) do
      :error -> conn |> put_status(500) |> json(%{error: "Invalid UUID"})
      {:ok, uu } -> 
        u_query = Query.from u in User,
          where: u.user_uuid == ^uu,
          select: u.id

        case u_query |> Repo.one do
          nil -> conn |> put_status(404) |> json(%{error: "User not found"})
          user_id -> 
            p_query = Query.from p in Poem,
              where: p.user_id == ^user_id

            poems =
              p_query
              |> Repo.all

            json conn, poems
        end
    end
  end
end
