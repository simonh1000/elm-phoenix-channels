defmodule Meep.ChatController do
  use Meep.Web, :controller

  def index(conn, %{"chat" => %{"code" => code}}) do
    render(conn, "index.html", code: code)
  end

end
