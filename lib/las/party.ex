defmodule Las.Party do
  def new do
    %{
      authorized: true,
      users: [],
      song_queue: [],
      currently_playing: []
      }
  end

  # def new(players) do
  #   players = Enum.map players, fn {name, info} ->
  #     {name, %{ default_player() | matches: info.matches || 0 }}
  #   end
  #   Map.put(new(), :players, Enum.into(players, %{}))
  # end

  # def default_player() do
  #   %{
  #     matches: 0, # of tiles matched
  #     turn: -1, # 1 is there turn and -1 mean they are a watcher
  #   }
  # end

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
    game
    |> Map.put(:users, users)
  end


end
