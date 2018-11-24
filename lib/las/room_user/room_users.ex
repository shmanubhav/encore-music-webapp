defmodule Las.RoomUsers do
  import Ecto.Query, warn: false
  alias Las.Repo

  alias Las.RoomUsers.RoomUser

  def create_room_user(attrs \\ %{}) do
    %RoomUser{}
    |> RoomUser.changeset(attrs)
    |> Repo.insert()
  end
  # get all of the rooms that the user is a member of
  def get_rooms_for_user(user_id) do
    room_users = Repo.all(RoomUser)
    Enum.filter(room_users, fn ru -> ru.user_id == user_id end)
  end

  # check if the user is already in the room
  def check_user(user_id, room_id) do
    room_users = Repo.all(RoomUser)
    Enum.filter(room_users, fn ru -> ru.user_id == user_id && ru.room_id == room_id end)
  end
end
