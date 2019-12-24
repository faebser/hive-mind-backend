defmodule HiveBackend.Repo.Migrations.CreatePoems do
  use Ecto.Migration

  def change do
    create table(:poems) do
      add :content, :text
      add :date_for, :date
      add :deleted, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:poems, [:user_id])
  end
end
