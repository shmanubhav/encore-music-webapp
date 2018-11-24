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
      song_queue: game.song_queue,
      currently_playing: game.currently_playing
    }
  end

  def add_user(game, user) do
    users = game.users ++ [user]
    login_user = Las.Users.get_user!(user)
    recently_played = Song.recently_played(login_user.token).songs
    songs = game.song_queue ++ [recently_played]
    game
    |> Map.put(:users, users)
    |> Map.put(:song_queue, songs)
  end

end
