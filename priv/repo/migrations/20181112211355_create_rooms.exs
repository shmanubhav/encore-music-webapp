defmodule Las.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :name, :string, null: false
      add :code, :integer, null: false

      timestamps()
    end

    create index(:rooms, [:name], unique: true)

  end
end
