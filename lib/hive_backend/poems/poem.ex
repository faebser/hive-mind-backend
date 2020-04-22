
defmodule HiveBackend.Poems.Poem do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:content, :date_for]}

  schema "poems" do
    field :content, :string
    field :date_for, :date
    field :deleted, :boolean, default: false
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(poem, attrs) do
    poem
    |> cast(attrs, [:content, :date_for, :deleted])
    |> validate_required([:content, :date_for])
  end
end
