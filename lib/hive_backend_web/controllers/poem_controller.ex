defmodule HiveBackendWeb.PoemController do
  use HiveBackendWeb, :controller

  alias HiveBackend.Poems
  alias HiveBackend.Poems.Poem

  def index(conn, _params) do
    poems = Poems.list_poems()
    render(conn, "index.html", poems: poems)
  end

  def new(conn, _params) do
    changeset = Poems.change_poem(%Poem{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"poem" => poem_params}) do
    case Poems.create_poem(poem_params) do
      {:ok, poem} ->
        conn
        |> put_flash(:info, "Poem created successfully.")
        |> redirect(to: Routes.poem_path(conn, :show, poem))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    poem = Poems.get_poem!(id)
    render(conn, "show.html", poem: poem)
  end

  def edit(conn, %{"id" => id}) do
    poem = Poems.get_poem!(id)
    changeset = Poems.change_poem(poem)
    render(conn, "edit.html", poem: poem, changeset: changeset)
  end

  def update(conn, %{"id" => id, "poem" => poem_params}) do
    poem = Poems.get_poem!(id)

    case Poems.update_poem(poem, poem_params) do
      {:ok, poem} ->
        conn
        |> put_flash(:info, "Poem updated successfully.")
        |> redirect(to: Routes.poem_path(conn, :show, poem))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", poem: poem, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    poem = Poems.get_poem!(id)
    {:ok, _poem} = Poems.delete_poem(poem)

    conn
    |> put_flash(:info, "Poem deleted successfully.")
    |> redirect(to: Routes.poem_path(conn, :index))
  end

  def random(conn, _params) do
    json conn, Poems.get_random_poem
  end

  def dataset( conn, _params ) do
    render conn, "poem.txt", poems: Poems.get_distinct_poems
  end
end
