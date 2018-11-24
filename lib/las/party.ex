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
    IO.puts("Got into ADD USER")
    login_user = Las.Users.get_user!(user)
    IO.inspect(login_user)
    users = game.users ++ [login_user]
    IO.inspect(users)
    recently_played = Song.recently_played(login_user.token).songs
    songs = game.song_queue ++ [recently_played]
    IO.inspect(songs)
    Map.put(game, :users, users)
    Map.put(game, :song_queue, songs)
    game
  end



end
