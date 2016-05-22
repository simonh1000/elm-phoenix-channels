defmodule Meep.PageController do
  use Meep.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
