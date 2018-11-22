defmodule Las.Repo.Migrations.RelationshipTables do
  use Ecto.Migration

  def change do
    create table(:room_user) do
      add :room_id, references(:rooms)
      add :user_id, references(:users)

      timestamps()
    end

    create table(:room_song) do
      add :room_id, references(:rooms)
      add :song_id, references(:songs)

      timestamps()
    end

  end
end
