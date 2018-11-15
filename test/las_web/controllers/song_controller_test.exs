defmodule LasWeb.SongControllerTest do
  use LasWeb.ConnCase

  alias Las.Songs

  @create_attrs %{author: "some author", playing: true, title: "some title"}
  @update_attrs %{author: "some updated author", playing: false, title: "some updated title"}
  @invalid_attrs %{author: nil, playing: nil, title: nil}

  def fixture(:song) do
    {:ok, song} = Songs.create_song(@create_attrs)
    song
  end

  describe "index" do
    test "lists all songs", %{conn: conn} do
      conn = get(conn, Routes.song_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Songs"
    end
  end

  describe "new song" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.song_path(conn, :new))
      assert html_response(conn, 200) =~ "New Song"
    end
  end

  describe "create song" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.song_path(conn, :create), song: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.song_path(conn, :show, id)

      conn = get(conn, Routes.song_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Song"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.song_path(conn, :create), song: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Song"
    end
  end

  describe "edit song" do
    setup [:create_song]

    test "renders form for editing chosen song", %{conn: conn, song: song} do
      conn = get(conn, Routes.song_path(conn, :edit, song))
      assert html_response(conn, 200) =~ "Edit Song"
    end
  end

  describe "update song" do
    setup [:create_song]

    test "redirects when data is valid", %{conn: conn, song: song} do
      conn = put(conn, Routes.song_path(conn, :update, song), song: @update_attrs)
      assert redirected_to(conn) == Routes.song_path(conn, :show, song)

      conn = get(conn, Routes.song_path(conn, :show, song))
      assert html_response(conn, 200) =~ "some updated author"
    end

    test "renders errors when data is invalid", %{conn: conn, song: song} do
      conn = put(conn, Routes.song_path(conn, :update, song), song: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Song"
    end
  end

  describe "delete song" do
    setup [:create_song]

    test "deletes chosen song", %{conn: conn, song: song} do
      conn = delete(conn, Routes.song_path(conn, :delete, song))
      assert redirected_to(conn) == Routes.song_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.song_path(conn, :show, song))
      end
    end
  end

  defp create_song(_) do
    song = fixture(:song)
    {:ok, song: song}
  end
end
