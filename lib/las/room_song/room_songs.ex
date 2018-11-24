defmodule Las.RoomSongs do
  import Ecto.Query, warn: false
  alias Las.Repo

  alias Las.RoomSongs.RoomSong

  def create_room_song(attrs \\ %{}) do
    %RoomSong{}
    |> RoomSong.changeset(attrs)
    |> Repo.insert()
  end

end
