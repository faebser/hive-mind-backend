defmodule HiveBackendWeb.InspirationsControllerTest do
  use HiveBackendWeb.ConnCase

  alias HiveBackend.Poems

  @create_attrs %{content: "some content", date_for: ~D[2010-04-17], deleted: true}
  @update_attrs %{content: "some updated content", date_for: ~D[2011-05-18], deleted: false}
  @invalid_attrs %{content: nil, date_for: nil, deleted: nil}

  def fixture(:inspirations) do
    {:ok, inspirations} = Poems.create_inspirations(@create_attrs)
    inspirations
  end

  describe "index" do
    test "lists all inspirations", %{conn: conn} do
      conn = get(conn, Routes.inspirations_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Inspirations"
    end
  end

  describe "new inspirations" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.inspirations_path(conn, :new))
      assert html_response(conn, 200) =~ "New Inspirations"
    end
  end

  describe "create inspirations" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.inspirations_path(conn, :create), inspirations: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.inspirations_path(conn, :show, id)

      conn = get(conn, Routes.inspirations_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Inspirations"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.inspirations_path(conn, :create), inspirations: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Inspirations"
    end
  end

  describe "edit inspirations" do
    setup [:create_inspirations]

    test "renders form for editing chosen inspirations", %{conn: conn, inspirations: inspirations} do
      conn = get(conn, Routes.inspirations_path(conn, :edit, inspirations))
      assert html_response(conn, 200) =~ "Edit Inspirations"
    end
  end

  describe "update inspirations" do
    setup [:create_inspirations]

    test "redirects when data is valid", %{conn: conn, inspirations: inspirations} do
      conn = put(conn, Routes.inspirations_path(conn, :update, inspirations), inspirations: @update_attrs)
      assert redirected_to(conn) == Routes.inspirations_path(conn, :show, inspirations)

      conn = get(conn, Routes.inspirations_path(conn, :show, inspirations))
      assert html_response(conn, 200) =~ "some updated content"
    end

    test "renders errors when data is invalid", %{conn: conn, inspirations: inspirations} do
      conn = put(conn, Routes.inspirations_path(conn, :update, inspirations), inspirations: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Inspirations"
    end
  end

  describe "delete inspirations" do
    setup [:create_inspirations]

    test "deletes chosen inspirations", %{conn: conn, inspirations: inspirations} do
      conn = delete(conn, Routes.inspirations_path(conn, :delete, inspirations))
      assert redirected_to(conn) == Routes.inspirations_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.inspirations_path(conn, :show, inspirations))
      end
    end
  end

  defp create_inspirations(_) do
    inspirations = fixture(:inspirations)
    {:ok, inspirations: inspirations}
  end
end
