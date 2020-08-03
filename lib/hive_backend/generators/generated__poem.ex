defmodule HiveBackend.Generators.Generated_Poem do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:content, :id]}

  schema "generated_poems" do
    field :content, :string
    field :from, :integer
    field :status, :integer

    timestamps()
  end

  @doc false
  def changeset(generated__poem, attrs) do
    generated__poem
    |> cast(attrs, [:content, :status, :from])
    |> validate_required([:content, :status, :from])
  end
end
