defmodule Las.Repo.Migrations.CreateSongs do
  use Ecto.Migration

  def change do
    create table(:songs) do
      add :title, :string, null: false
      add :author, :string
      add :uri, :string, null: false
      add :playing, :boolean, default: false, null: false

      timestamps()
    end
    create index(:songs, [:uri], unique: true)

  end
end
