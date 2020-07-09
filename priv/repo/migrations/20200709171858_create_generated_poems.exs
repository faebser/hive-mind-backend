defmodule HiveBackend.Repo.Migrations.CreateGeneratedPoems do
  use Ecto.Migration

  def change do
    create table(:generated_poems) do
      add :content, :string
      add :status, :integer
      add :from, :integer

      timestamps()
    end

  end
end
