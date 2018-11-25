defmodule Las.Rooms.Room do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rooms" do
    field :code, :integer, null: false
    field :name, :string, null: false
    belongs_to :user, Las.Users.User

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:name, :code, :user_id])
    |> unique_constraint(:name)
    |> validate_required([:name, :code])
  end
end
