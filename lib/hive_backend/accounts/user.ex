defmodule HiveBackend.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :active, :boolean, default: false
    field :deleted, :boolean, default: false
    field :user_uuid, Ecto.UUID

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:active, :deleted, :user_uuid])
    |> validate_required([:active, :deleted, :user_uuid])
  end
end
