defmodule LasWeb.PageController do
  use LasWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

end
