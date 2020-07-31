defmodule HiveBackend.Repo.Migrations.CreateGeneratedPoems do
  use Ecto.Migration

  def change do
    alter table(:generated_poems) do
      modify :content, :text
    end

  end
end
