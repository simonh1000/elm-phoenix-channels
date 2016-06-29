defmodule Meep.ChatControllerTest do
  use Meep.ConnCase

  alias Meep.Chat
  @valid_attrs %{}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, chat_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing chats"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, chat_path(conn, :new)
    assert html_response(conn, 200) =~ "New chat"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, chat_path(conn, :create), chat: @valid_attrs
    assert redirected_to(conn) == chat_path(conn, :index)
    assert Repo.get_by(Chat, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, chat_path(conn, :create), chat: @invalid_attrs
    assert html_response(conn, 200) =~ "New chat"
  end

  test "shows chosen resource", %{conn: conn} do
    chat = Repo.insert! %Chat{}
    conn = get conn, chat_path(conn, :show, chat)
    assert html_response(conn, 200) =~ "Show chat"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, chat_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    chat = Repo.insert! %Chat{}
    conn = get conn, chat_path(conn, :edit, chat)
    assert html_response(conn, 200) =~ "Edit chat"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    chat = Repo.insert! %Chat{}
    conn = put conn, chat_path(conn, :update, chat), chat: @valid_attrs
    assert redirected_to(conn) == chat_path(conn, :show, chat)
    assert Repo.get_by(Chat, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    chat = Repo.insert! %Chat{}
    conn = put conn, chat_path(conn, :update, chat), chat: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit chat"
  end

  test "deletes chosen resource", %{conn: conn} do
    chat = Repo.insert! %Chat{}
    conn = delete conn, chat_path(conn, :delete, chat)
    assert redirected_to(conn) == chat_path(conn, :index)
    refute Repo.get(Chat, chat.id)
  end
end
