defmodule HiveBackend.Repo.Migrations.CreateInspirations do
  use Ecto.Migration

  def change do
    create table(:inspirations) do
      add :content, :text
      add :date_for, :date
      add :deleted, :boolean, default: false, null: false
      add :theme_id, references(:themes, on_delete: :nothing)

      timestamps()
    end

    create index(:inspirations, [:theme_id])
  end
end
