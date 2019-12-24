defmodule HiveBackendWeb.PageController do
  use HiveBackendWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
