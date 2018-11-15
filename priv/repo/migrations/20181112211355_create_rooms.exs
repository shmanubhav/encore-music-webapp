defmodule Las.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :name, :string
      add :code, :integer

      timestamps()
    end

  end
end
