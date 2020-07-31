defmodule HiveBackend.Generators do
  @moduledoc """
  The Generators context.
  """

  import Ecto.Query, warn: false
  alias HiveBackend.Repo

  alias HiveBackend.Generators.Generated_Poem
  alias HiveBackend.Generators.Markov
  alias HiveBackend.Generators.Queneau
  alias HiveBackend.Generators.Thesaurus
  alias HiveBackend.Poems

  @by_markov 1
  @by_queneau 2
  @by_thesaurus 3

  def by_markov do
    @by_markov
  end

  def by_queneau do
    @by_queneau
  end

  @doc """
  Returns the list of generated_poems.

  ## Examples

      iex> list_generated_poems()
      [%Generated_Poem{}, ...]

  """
  def list_generated_poems do
    Repo.all(Generated_Poem)
  end

  @doc """
  Gets a single generated__poem.

  Raises `Ecto.NoResultsError` if the Generated  poem does not exist.

  ## Examples

      iex> get_generated__poem!(123)
      %Generated_Poem{}

      iex> get_generated__poem!(456)
      ** (Ecto.NoResultsError)

  """
  def get_generated__poem!(id), do: Repo.get!(Generated_Poem, id)

  @doc """
  Creates a generated__poem.

  ## Examples

      iex> create_generated__poem(%{field: value})
      {:ok, %Generated_Poem{}}

      iex> create_generated__poem(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_generated__poem(attrs \\ %{}) do
    %Generated_Poem{}
    |> Generated_Poem.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a generated__poem.

  ## Examples

      iex> update_generated__poem(generated__poem, %{field: new_value})
      {:ok, %Generated_Poem{}}

      iex> update_generated__poem(generated__poem, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_generated__poem(%Generated_Poem{} = generated__poem, attrs) do
    generated__poem
    |> Generated_Poem.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Generated_Poem.

  ## Examples

      iex> delete_generated__poem(generated__poem)
      {:ok, %Generated_Poem{}}

      iex> delete_generated__poem(generated__poem)
      {:error, %Ecto.Changeset{}}

  """
  def delete_generated__poem(%Generated_Poem{} = generated__poem) do
    Repo.delete(generated__poem)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking generated__poem changes.

  ## Examples

      iex> change_generated__poem(generated__poem)
      %Ecto.Changeset{source: %Generated_Poem{}}

  """
  def change_generated__poem(%Generated_Poem{} = generated__poem) do
    Generated_Poem.changeset(generated__poem, %{})
  end

  def insert( poems ) do
    Enum.map( poems, fn p ->  Repo.insert p end)
  end

  def generate_from_markov( amount ) do

    { :ok, pid } = Markov.start_link
    Markov.load_all_poems pid

    0..amount
    |> Enum.map( fn _i ->

      { :ok, %Generated_Poem{
        content: Markov.get( pid ),
        from: @by_markov,
        status: 0
      } }

    end)
  end

  def generate_from_queneau( amount ) do

    { :ok, pid } = Queneau.start_link
    Queneau.add_all_poems pid, &Poems.get_distinct_poems/0

    0..amount
    |> Enum.map( fn _i ->

      { :ok, %Generated_Poem{
        content: Queneau.generate( pid, 10 ),
        from: @by_markov,
        status: 0
      } }

    end)
  end

  def generate_from_thesaurus( amount ) do
    
    0..amount
    |> Enum.map( fn _i ->

      p =
      Poems.get_random_poem
      |> Map.get( :content )
      |> Thesaurus.generate

      case p do
        { :ok, p } ->
          { :ok, %Generated_Poem{
            content: p,
            from: @by_thesaurus,
            status: 0
            } }
        { :error, reason } -> { :error, reason }
      end
    end)
  end
end
