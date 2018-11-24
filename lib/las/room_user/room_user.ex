defmodule Las.RoomUsers.RoomUser do
  use Ecto.Schema
  import Ecto.Changeset

  schema "room_user" do
    belongs_to :user, Las.Users.User
    belongs_to :room, Las.Rooms.Room

    timestamps()
  end

  @doc false
  def changeset(roomuser, attrs) do
    roomuser
    |> cast(attrs, [:user_id, :room_id])
  end
end
