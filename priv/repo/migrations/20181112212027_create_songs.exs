defmodule Las.Repo.Migrations.CreateSongs do
  use Ecto.Migration

  def change do
    create table(:songs) do
      add :title, :string
      add :author, :string
      add :uri, :string
      add :playing, :boolean, default: false, null: false

      timestamps()
    end

  end
end
