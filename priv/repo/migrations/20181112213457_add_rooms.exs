defmodule Las.Repo.Migrations.AddRooms do
  use Ecto.Migration

  def change do
    alter table(:users) do
     add :room_id, references(:rooms)
    end
    alter table(:songs) do
     add :room_id, references(:rooms)
    end
  end
end
