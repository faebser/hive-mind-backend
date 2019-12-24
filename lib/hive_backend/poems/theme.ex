defmodule HiveBackend.Poems.Theme do
  use Ecto.Schema
  import Ecto.Changeset

  schema "themes" do
    field :content, :string
    field :date_for, :date
    field :deleted, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(theme, attrs) do
    theme
    |> cast(attrs, [:content, :date_for, :deleted])
    |> validate_required([:content, :date_for, :deleted])
  end
end
