defmodule Las.RoomSongs do
  import Ecto.Query, warn: false
  alias Las.Repo

  alias Las.RoomSongs.RoomSong

  def create_room_song(attrs \\ %{}) do
    %RoomSong{}
    |> RoomSong.changeset(attrs)
    |> Repo.insert()
  end

  # Retrieve all songs that are in the given room id
  def get_queue(r_id) do
    rooms = Repo.all(Las.RoomSongs.RoomSong)
    Enum.filter(rooms, fn r -> r.room_id == r_id end) |> Repo.preload([:song])
  end

end
