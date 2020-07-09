defmodule HiveBackendWeb.Generated_PoemControllerTest do
  use HiveBackendWeb.ConnCase

  alias HiveBackend.Generators

  @create_attrs %{content: "some content", from: 42, status: 42}
  @update_attrs %{content: "some updated content", from: 43, status: 43}
  @invalid_attrs %{content: nil, from: nil, status: nil}

  def fixture(:generated__poem) do
    {:ok, generated__poem} = Generators.create_generated__poem(@create_attrs)
    generated__poem
  end

  describe "index" do
    test "lists all generated_poems", %{conn: conn} do
      conn = get(conn, Routes.generated__poem_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Generated poems"
    end
  end

  describe "new generated__poem" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.generated__poem_path(conn, :new))
      assert html_response(conn, 200) =~ "New Generated  poem"
    end
  end

  describe "create generated__poem" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.generated__poem_path(conn, :create), generated__poem: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.generated__poem_path(conn, :show, id)

      conn = get(conn, Routes.generated__poem_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Generated  poem"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.generated__poem_path(conn, :create), generated__poem: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Generated  poem"
    end
  end

  describe "edit generated__poem" do
    setup [:create_generated__poem]

    test "renders form for editing chosen generated__poem", %{conn: conn, generated__poem: generated__poem} do
      conn = get(conn, Routes.generated__poem_path(conn, :edit, generated__poem))
      assert html_response(conn, 200) =~ "Edit Generated  poem"
    end
  end

  describe "update generated__poem" do
    setup [:create_generated__poem]

    test "redirects when data is valid", %{conn: conn, generated__poem: generated__poem} do
      conn = put(conn, Routes.generated__poem_path(conn, :update, generated__poem), generated__poem: @update_attrs)
      assert redirected_to(conn) == Routes.generated__poem_path(conn, :show, generated__poem)

      conn = get(conn, Routes.generated__poem_path(conn, :show, generated__poem))
      assert html_response(conn, 200) =~ "some updated content"
    end

    test "renders errors when data is invalid", %{conn: conn, generated__poem: generated__poem} do
      conn = put(conn, Routes.generated__poem_path(conn, :update, generated__poem), generated__poem: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Generated  poem"
    end
  end

  describe "delete generated__poem" do
    setup [:create_generated__poem]

    test "deletes chosen generated__poem", %{conn: conn, generated__poem: generated__poem} do
      conn = delete(conn, Routes.generated__poem_path(conn, :delete, generated__poem))
      assert redirected_to(conn) == Routes.generated__poem_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.generated__poem_path(conn, :show, generated__poem))
      end
    end
  end

  defp create_generated__poem(_) do
    generated__poem = fixture(:generated__poem)
    {:ok, generated__poem: generated__poem}
  end
end
