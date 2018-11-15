defmodule LasWeb.PageController do
  use LasWeb, :controller

  def index(conn, _params) do
    IO.puts("Got here in the page controller index")
    render(conn, "index.html")
  end

end
