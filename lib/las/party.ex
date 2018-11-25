defmodule Las.Party do

  alias Las.Songs.Song

  def new do
    %{
      authorized: true,
      users: [],
      song_queue: [],
      currently_playing: []
      }
  end

  def client_view(game, user) do
    %{
      authorized: game.authorized,
      users: game.users,
      song_queue: List.flatten(game.song_queue),
      currently_playing: game.currently_playing,
      party_name: ""
    }
  end

  def set_party_name(game, name) do
    game
    |> Map.put(:party_name, name)
  end

  def add_user(game, user) do

    if Enum.member?(game.users, user) == false do
      users = game.users ++ [user]
      login_user = Las.Users.get_user!(user)
      recently_played = Song.recently_played(login_user.token).songs

      # Add these songs to Song DB.
      Enum.map(recently_played, fn x ->
          if Las.Songs.get_song_uri(x.uri) do
          else
            Las.Songs.create_song(%{title: x.title, author: Enum.at(x.artists, 0).name, playing: false, uri: x.uri})
          end
        end)

      # Add the songs to room_songs db
      Enum.map(recently_played, fn x ->
          song = Las.Songs.get_song_uri(x.uri)
          room = Las.Rooms.get_room_by_name(game.party_name)
          if song != nil and room != nil do
            Las.RoomSongs.create_room_song(%{room_id: room.id, song_id: song.id})
          end
        end)

      songs = game.song_queue ++ [recently_played]
      game
      |> Map.put(:users, users)
      |> Map.put(:song_queue, List.flatten(songs))
    else
      game
    end

 end
end
