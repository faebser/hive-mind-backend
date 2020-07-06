defmodule HiveBackend.Poems do
  @moduledoc """
  The Poems context.
  """

  import Ecto.Query, warn: false
  alias HiveBackend.Repo

  alias HiveBackend.Poems.Theme

  @doc """
  Returns the list of themes.

  ## Examples

      iex> list_themes()
      [%Theme{}, ...]

  """
  def list_themes do
    Repo.all(Theme)
  end

  @doc """
  Gets a single theme.

  Raises `Ecto.NoResultsError` if the Theme does not exist.

  ## Examples

      iex> get_theme!(123)
      %Theme{}

      iex> get_theme!(456)
      ** (Ecto.NoResultsError)

  """
  def get_theme!(id), do: Repo.get!(Theme, id)

  @doc """
  Creates a theme.

  ## Examples

      iex> create_theme(%{field: value})
      {:ok, %Theme{}}

      iex> create_theme(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_theme(attrs \\ %{}) do
    %Theme{}
    |> Theme.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a theme.

  ## Examples

      iex> update_theme(theme, %{field: new_value})
      {:ok, %Theme{}}

      iex> update_theme(theme, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_theme(%Theme{} = theme, attrs) do
    theme
    |> Theme.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Theme.

  ## Examples

      iex> delete_theme(theme)
      {:ok, %Theme{}}

      iex> delete_theme(theme)
      {:error, %Ecto.Changeset{}}

  """
  def delete_theme(%Theme{} = theme) do
    Repo.delete(theme)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking theme changes.

  ## Examples

      iex> change_theme(theme)
      %Ecto.Changeset{source: %Theme{}}

  """
  def change_theme(%Theme{} = theme) do
    Theme.changeset(theme, %{})
  end

  alias HiveBackend.Poems.Inspirations

  @doc """
  Returns the list of inspirations.

  ## Examples

      iex> list_inspirations()
      [%Inspirations{}, ...]

  """
  def list_inspirations do
    Repo.all(Inspirations)
  end

  @doc """
  Gets a single inspirations.

  Raises `Ecto.NoResultsError` if the Inspirations does not exist.

  ## Examples

      iex> get_inspirations!(123)
      %Inspirations{}

      iex> get_inspirations!(456)
      ** (Ecto.NoResultsError)

  """
  def get_inspirations!(id), do: Repo.get!(Inspirations, id)

  @doc """
  Creates a inspirations.

  ## Examples

      iex> create_inspirations(%{field: value})
      {:ok, %Inspirations{}}

      iex> create_inspirations(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_inspirations(attrs \\ %{}) do
    %Inspirations{}
    |> Inspirations.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a inspirations.

  ## Examples

      iex> update_inspirations(inspirations, %{field: new_value})
      {:ok, %Inspirations{}}

      iex> update_inspirations(inspirations, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_inspirations(%Inspirations{} = inspirations, attrs) do
    inspirations
    |> Inspirations.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Inspirations.

  ## Examples

      iex> delete_inspirations(inspirations)
      {:ok, %Inspirations{}}

      iex> delete_inspirations(inspirations)
      {:error, %Ecto.Changeset{}}

  """
  def delete_inspirations(%Inspirations{} = inspirations) do
    Repo.delete(inspirations)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking inspirations changes.

  ## Examples

      iex> change_inspirations(inspirations)
      %Ecto.Changeset{source: %Inspirations{}}

  """
  def change_inspirations(%Inspirations{} = inspirations) do
    Inspirations.changeset(inspirations, %{})
  end

  alias HiveBackend.Poems.Poem

  @doc """
  Returns the list of poems.

  ## Examples

      iex> list_poems()
      [%Poem{}, ...]

  """
  def list_poems do
    Repo.all(Poem)
  end

  @doc """
  Gets a single poem.

  Raises `Ecto.NoResultsError` if the Poem does not exist.

  ## Examples

      iex> get_poem!(123)
      %Poem{}

      iex> get_poem!(456)
      ** (Ecto.NoResultsError)

  """
  def get_poem!(id), do: Repo.get!(Poem, id)

    @doc """
  Gets a single random poem.

  """
  def get_random_poem() do
    q = from Poem, order_by: fragment("RANDOM()"), limit: 1
    q |> Repo.one()
  end

  def get_distinct_poems() do
   from( Poem, distinct: :content, order_by: [ asc: :date_for ] ) |> Repo.all
  end

  @doc """
  Creates a poem.

  ## Examples

      iex> create_poem(%{field: value})
      {:ok, %Poem{}}

      iex> create_poem(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_poem(attrs \\ %{}) do
    %Poem{}
    |> Poem.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a poem.

  ## Examples

      iex> update_poem(poem, %{field: new_value})
      {:ok, %Poem{}}

      iex> update_poem(poem, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_poem(%Poem{} = poem, attrs) do
    poem
    |> Poem.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Poem.

  ## Examples

      iex> delete_poem(poem)
      {:ok, %Poem{}}

      iex> delete_poem(poem)
      {:error, %Ecto.Changeset{}}

  """
  def delete_poem(%Poem{} = poem) do
    Repo.delete(poem)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking poem changes.

  ## Examples

      iex> change_poem(poem)
      %Ecto.Changeset{source: %Poem{}}

  """
  def change_poem(%Poem{} = poem) do
    Poem.changeset(poem, %{})
  end
end
