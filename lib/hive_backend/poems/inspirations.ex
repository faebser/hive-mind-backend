defmodule HiveBackend.Poems.Inspirations do
  use Ecto.Schema
  import Ecto.Changeset

  schema "inspirations" do
    field :content, :string
    field :date_for, :date
    field :deleted, :boolean, default: false
    field :theme_id, :id

    timestamps()
  end

  @doc false
  def changeset(inspirations, attrs) do
    inspirations
    |> cast(attrs, [:content, :date_for, :deleted])
    |> validate_required([:content, :date_for, :deleted])
  end
end
