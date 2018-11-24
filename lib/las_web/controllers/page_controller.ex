defmodule LasWeb.PageController do
  use LasWeb, :controller

  alias Las.Rooms
  alias Las.RoomUsers
  alias Las.Songs.Song

  def index(conn, _params) do
    user = get_session(conn, :current_user)
    if user do
      conn
      |> redirect(to: "/explore")
    else
      render(conn, "index.html")
    end
  end

  def explore(conn, _params) do
    access_token = get_session(conn, :access_token)
    recently_played = Song.recently_played(access_token).songs
    user = get_session(conn, :current_login_user)
    room_ids = Enum.map(RoomUsers.get_rooms_for_user(user.id), fn ri -> ri.room_id end)
    rooms = Enum.map(room_ids, fn ri -> Rooms.get_room_id(ri) end)
    render(conn, "explore.html", recent_songs: recently_played, rooms: rooms)
  end

  def enter(conn, %{"enter" => %{"party_name" => party_name}}) do
    room = Rooms.get_room(party_name)
    user = get_session(conn, :current_login_user)
    cond do
      room && (user.id == room.user_id) ->
        conn
        |> redirect(to: "/party/#{party_name}")
      room ->
        render(conn, "enter.html", party_name: party_name)
      true ->
        conn
        |> put_flash(:error, "Party Does Not Exist")
        |> redirect(to: "/explore")
    end
  end

  def join(conn, %{"join" => %{"party_name" => party_name, "party_code" => party_code}}) do
    IO.inspect("Got here")
    # check that the fields are filled out.
    if party_name == "" or party_code == "" do
      conn
      |> put_flash(:error, "Please Enter a Party Room and Code")
      |> redirect(to: "/enter")
    end
    IO.inspect("Got here 2")

    user = get_session(conn, :current_login_user)
    # Validate that the code is correct.
    room = Rooms.validate_code(party_name, party_code)
    IO.inspect("Got here 3")
    if room do
      roomuser = RoomUsers.room_contains_user(user.id, room.id)
      # If user gave the right code and they aren't part of the group, add them and proceed
      if !roomuser do
        case RoomUsers.create_room_user(%{room_id: room.id, user_id: user.id}) do
          {:ok, roomuser} ->
            conn
            |> put_session(:party_name, party_name)
            |> redirect(to: "/party/#{party_name}")
          {:error, %Ecto.Changeset{} = changeset} ->
              render(conn, "/", changeset: changeset)
          end
        else
          conn
          |> put_session(:party_name, party_name)
          |> redirect(to: "/party/#{party_name}")
      end
    else
      conn
      |> put_flash(:error, "Denied joining Party Room: Incorrect room code.")
      |> redirect(to: "/")
    end
  end

  def party(conn, %{"party" => party_name}) do
    user = get_session(conn, :current_login_user)
    spotify_user = get_session(conn, :current_user)
    room = Rooms.get_room(party_name)

    if !room do
      conn
      |> put_flash(:error, "Denied joining Party Room. Room doesn't exist.")
      |> redirect(to: "/")
    end

    # Check if user belongs to this room.
    in_room = RoomUsers.room_contains_user(user.id, room.id)

    if in_room do
      conn
      |> put_session(:party_name, party_name)
      |> render("party_room.html", party_name: party_name , user: user, spotify_user: spotify_user, party_id: room.id)
      #render conn, "party_room.html", party_name: party_name, party_id: room.id, user: user, spotify_user: spotify_user
    else
    conn
      |> put_flash(:error, "Denied joining Party Room.")
      |> redirect(to: "/")

    end
  end
end
