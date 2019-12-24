defmodule HiveBackend.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :active, :boolean, default: false, null: false
      add :deleted, :boolean, default: false, null: false
      add :user_uuid, :uuid

      timestamps()
    end

  end
end
