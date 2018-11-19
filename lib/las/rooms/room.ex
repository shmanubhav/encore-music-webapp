defmodule Las.Rooms.Room do
  use Ecto.Schema
  import Ecto.Changeset


  schema "rooms" do
    field :code, :integer
    field :name, :string
    has_many :user, Las.Users.User
    has_many :song, Las.Songs.Song

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:name, :code])
    |> unique_constraint(:name)
    |> validate_required([:name, :code])
  end
end
