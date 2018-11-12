defmodule LasWeb.PageController do
  use LasWeb, :controller

  def index(conn, _params) do
    IO.puts("Got here in the page controller index")
    render(conn, "index.html")
  end

  # def login(conn, _params) do
  #   IO.puts("Got to the login page")
  #
  #   url = ("https://accounts.spotify.com/authorize" <>
  #     "?response_type=code"<>
  #     "&client_id=" <> "89c07b366d364483851512fc85002c6a" <>
  #     "&scope=" <> URI.encode("user-read-private")<> ":"<> "" <>
  #     "&redirect_uri=" <> URI.encode("https://www.google.com/"));
  #
  #     IO.inspect(url)
  #
  #   stuff = HTTPoison.get!(url)
  #   |>Map.get(:body)
  #   render(conn, "index.html")
  #
  # end
end
