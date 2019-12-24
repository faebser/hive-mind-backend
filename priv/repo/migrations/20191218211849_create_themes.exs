defmodule HiveBackend.Repo.Migrations.CreateThemes do
  use Ecto.Migration

  def change do
    create table(:themes) do
      add :content, :text
      add :date_for, :date
      add :deleted, :boolean, default: false, null: false

      timestamps()
    end

  end
end
