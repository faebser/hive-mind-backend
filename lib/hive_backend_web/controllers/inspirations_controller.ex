defmodule HiveBackendWeb.InspirationsController do
  use HiveBackendWeb, :controller

  alias HiveBackend.Poems
  alias HiveBackend.Poems.Inspirations

  def index(conn, _params) do
    inspirations = Poems.list_inspirations()
    render(conn, "index.html", inspirations: inspirations)
  end

  def new(conn, _params) do
    changeset = Poems.change_inspirations(%Inspirations{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"inspirations" => inspirations_params}) do
    case Poems.create_inspirations(inspirations_params) do
      {:ok, inspirations} ->
        conn
        |> put_flash(:info, "Inspirations created successfully.")
        |> redirect(to: Routes.inspirations_path(conn, :show, inspirations))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    inspirations = Poems.get_inspirations!(id)
    render(conn, "show.html", inspirations: inspirations)
  end

  def edit(conn, %{"id" => id}) do
    inspirations = Poems.get_inspirations!(id)
    changeset = Poems.change_inspirations(inspirations)
    render(conn, "edit.html", inspirations: inspirations, changeset: changeset)
  end

  def update(conn, %{"id" => id, "inspirations" => inspirations_params}) do
    inspirations = Poems.get_inspirations!(id)

    case Poems.update_inspirations(inspirations, inspirations_params) do
      {:ok, inspirations} ->
        conn
        |> put_flash(:info, "Inspirations updated successfully.")
        |> redirect(to: Routes.inspirations_path(conn, :show, inspirations))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", inspirations: inspirations, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    inspirations = Poems.get_inspirations!(id)
    {:ok, _inspirations} = Poems.delete_inspirations(inspirations)

    conn
    |> put_flash(:info, "Inspirations deleted successfully.")
    |> redirect(to: Routes.inspirations_path(conn, :index))
  end
end
