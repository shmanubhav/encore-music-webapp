defmodule Las.RoomUsers do
  import Ecto.Query, warn: false
  alias Las.Repo

  alias Las.RoomUsers.RoomUser

  def create_room_user(attrs \\ %{}) do
    %RoomUser{}
    |> RoomUser.changeset(attrs)
    |> Repo.insert()
  end

end
