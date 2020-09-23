defmodule HiveBackendWeb.Generated_PoemController do
  use HiveBackendWeb, :controller

  alias HiveBackend.Generators
  alias HiveBackend.Generators.Generated_Poem
  alias HiveBackend.Repo

  @approved 1
  @rejected 2  

  def index(conn, _params) do
    generated_poems = 
    Generators.list_generated_poems()
    |> Enum.map( fn p ->
      %{ p | :content => String.split( p.content, "\n" ) }
    end)
    render(conn, "index.html", generated_poems: generated_poems)
  end

  def new(conn, _params) do
    changeset = Generators.change_generated__poem(%Generated_Poem{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"generated__poem" => generated__poem_params}) do
    case Generators.create_generated__poem(generated__poem_params) do
      {:ok, generated__poem} ->
        conn
        |> put_flash(:info, "Generated  poem created successfully.")
        |> redirect(to: Routes.generated__poem_path(conn, :show, generated__poem))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    generated__poem = Generators.get_generated__poem!(id)

    content = generated__poem.content |> String.split("\n")

    render(conn, "show.html", generated__poem: generated__poem, content: content)
  end

  def edit(conn, %{"id" => id}) do
    generated__poem = Generators.get_generated__poem!(id)
    changeset = Generators.change_generated__poem(generated__poem)
    render(conn, "edit.html", generated__poem: generated__poem, changeset: changeset)
  end

  def update(conn, %{"id" => id, "generated__poem" => generated__poem_params}) do
    generated__poem = Generators.get_generated__poem!(id)

    case Generators.update_generated__poem(generated__poem, generated__poem_params) do
      {:ok, generated__poem} ->
        conn
        |> put_flash(:info, "Generated  poem updated successfully.")
        |> redirect(to: Routes.generated__poem_path(conn, :show, generated__poem))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", generated__poem: generated__poem, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    generated__poem = Generators.get_generated__poem!(id)
    {:ok, _generated__poem} = Generators.delete_generated__poem(generated__poem)

    conn
    |> put_flash(:info, "Generated  poem deleted successfully.")
    |> redirect(to: Routes.generated__poem_path(conn, :index))
  end

  def markov( con, %{"amount" => amount} ) do
    { amount, _ } = Integer.parse amount
    p = Enum.map(Generators.generate_from_markov( amount ), fn p ->
      case p do
         { :ok, poem } -> Repo.insert poem
         { :error, reason } -> { :error, reason }
      end
    end)

    l =
    p
    |> Enum.filter( fn { status, _ } -> status == :ok end)
    |> length()

    con
    |> put_flash(:info, "Generated #{ l } markov poems successfully.")
    |> redirect(to: Routes.generated__poem_path( con, :index ))

  end

  def thesaurus( con, %{"amount" => amount} ) do
    { amount, _ } = Integer.parse amount
    p = Enum.map(Generators.generate_from_thesaurus( amount ), fn p ->
      case p do
         { :ok, poem } -> Repo.insert poem
         { :error, reason } -> { :error, reason }
      end
    end)

    l =
    p
    |> Enum.filter( fn { status, _ } -> status == :ok end)
    |> length()

    con
    |> put_flash(:info, "Generated #{ l } thesaurus poems successfully.")
    |> redirect(to: Routes.generated__poem_path( con, :index ))

  end

  def queneau( con, %{"amount" => amount} ) do
    { amount, _ } = Integer.parse amount
    p = Enum.map(Generators.generate_from_queneau( amount ), fn p ->
      case p do
         { :ok, poem } -> Repo.insert poem
         { :error, reason } -> { :error, reason }
      end
    end)

    l =
    p
    |> Enum.filter( fn { status, _ } -> status == :ok end)
    |> length()

    con
    |> put_flash(:info, "Generated #{ l } queneau poems successfully.")
    |> redirect(to: Routes.generated__poem_path( con, :index ))

  end

  def random( conn, _params ) do
    p = Generators.get_ten_random_poems()
    
    json conn, p
  end

  def approve( conn, %{ "id" => id }) do

    generated__poem = Generators.get_generated__poem!( id )

    case Generators.update_generated__poem(generated__poem, %{ :status => Generators.approved } ) do
      {:ok, _generated__poem} -> json( conn, "ok" )
      {:error, %Ecto.Changeset{} = changeset} -> json( conn, changeset )
    end
  end

  def reject( conn, %{ "id" => id }) do

    generated__poem = Generators.get_generated__poem!( id )

    case Generators.update_generated__poem(generated__poem, %{ :status => Generators.rejected } ) do
      {:ok, _generated__poem} -> json( conn, "ok" )
      {:error, %Ecto.Changeset{} = changeset} -> json( conn, changeset )
    end
  end

  def dataset( conn, _params ) do
    render conn, "poem.txt", poems: Generators.get_all_poems_with_good_rating
  end
end
