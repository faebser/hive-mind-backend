defmodule HiveBackend.PoemsTest do
  use HiveBackend.DataCase

  alias HiveBackend.Poems

  describe "themes" do
    alias HiveBackend.Poems.Theme

    @valid_attrs %{content: "some content", date_for: ~D[2010-04-17], deleted: true}
    @update_attrs %{content: "some updated content", date_for: ~D[2011-05-18], deleted: false}
    @invalid_attrs %{content: nil, date_for: nil, deleted: nil}

    def theme_fixture(attrs \\ %{}) do
      {:ok, theme} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Poems.create_theme()

      theme
    end

    test "list_themes/0 returns all themes" do
      theme = theme_fixture()
      assert Poems.list_themes() == [theme]
    end

    test "get_theme!/1 returns the theme with given id" do
      theme = theme_fixture()
      assert Poems.get_theme!(theme.id) == theme
    end

    test "create_theme/1 with valid data creates a theme" do
      assert {:ok, %Theme{} = theme} = Poems.create_theme(@valid_attrs)
      assert theme.content == "some content"
      assert theme.date_for == ~D[2010-04-17]
      assert theme.deleted == true
    end

    test "create_theme/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Poems.create_theme(@invalid_attrs)
    end

    test "update_theme/2 with valid data updates the theme" do
      theme = theme_fixture()
      assert {:ok, %Theme{} = theme} = Poems.update_theme(theme, @update_attrs)
      assert theme.content == "some updated content"
      assert theme.date_for == ~D[2011-05-18]
      assert theme.deleted == false
    end

    test "update_theme/2 with invalid data returns error changeset" do
      theme = theme_fixture()
      assert {:error, %Ecto.Changeset{}} = Poems.update_theme(theme, @invalid_attrs)
      assert theme == Poems.get_theme!(theme.id)
    end

    test "delete_theme/1 deletes the theme" do
      theme = theme_fixture()
      assert {:ok, %Theme{}} = Poems.delete_theme(theme)
      assert_raise Ecto.NoResultsError, fn -> Poems.get_theme!(theme.id) end
    end

    test "change_theme/1 returns a theme changeset" do
      theme = theme_fixture()
      assert %Ecto.Changeset{} = Poems.change_theme(theme)
    end
  end

  describe "inspirations" do
    alias HiveBackend.Poems.Inspirations

    @valid_attrs %{content: "some content", date_for: ~D[2010-04-17], deleted: true}
    @update_attrs %{content: "some updated content", date_for: ~D[2011-05-18], deleted: false}
    @invalid_attrs %{content: nil, date_for: nil, deleted: nil}

    def inspirations_fixture(attrs \\ %{}) do
      {:ok, inspirations} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Poems.create_inspirations()

      inspirations
    end

    test "list_inspirations/0 returns all inspirations" do
      inspirations = inspirations_fixture()
      assert Poems.list_inspirations() == [inspirations]
    end

    test "get_inspirations!/1 returns the inspirations with given id" do
      inspirations = inspirations_fixture()
      assert Poems.get_inspirations!(inspirations.id) == inspirations
    end

    test "create_inspirations/1 with valid data creates a inspirations" do
      assert {:ok, %Inspirations{} = inspirations} = Poems.create_inspirations(@valid_attrs)
      assert inspirations.content == "some content"
      assert inspirations.date_for == ~D[2010-04-17]
      assert inspirations.deleted == true
    end

    test "create_inspirations/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Poems.create_inspirations(@invalid_attrs)
    end

    test "update_inspirations/2 with valid data updates the inspirations" do
      inspirations = inspirations_fixture()
      assert {:ok, %Inspirations{} = inspirations} = Poems.update_inspirations(inspirations, @update_attrs)
      assert inspirations.content == "some updated content"
      assert inspirations.date_for == ~D[2011-05-18]
      assert inspirations.deleted == false
    end

    test "update_inspirations/2 with invalid data returns error changeset" do
      inspirations = inspirations_fixture()
      assert {:error, %Ecto.Changeset{}} = Poems.update_inspirations(inspirations, @invalid_attrs)
      assert inspirations == Poems.get_inspirations!(inspirations.id)
    end

    test "delete_inspirations/1 deletes the inspirations" do
      inspirations = inspirations_fixture()
      assert {:ok, %Inspirations{}} = Poems.delete_inspirations(inspirations)
      assert_raise Ecto.NoResultsError, fn -> Poems.get_inspirations!(inspirations.id) end
    end

    test "change_inspirations/1 returns a inspirations changeset" do
      inspirations = inspirations_fixture()
      assert %Ecto.Changeset{} = Poems.change_inspirations(inspirations)
    end
  end

  describe "poems" do
    alias HiveBackend.Poems.Poem

    @valid_attrs %{content: "some content", date_for: ~D[2010-04-17], deleted: true}
    @update_attrs %{content: "some updated content", date_for: ~D[2011-05-18], deleted: false}
    @invalid_attrs %{content: nil, date_for: nil, deleted: nil}

    def poem_fixture(attrs \\ %{}) do
      {:ok, poem} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Poems.create_poem()

      poem
    end

    test "list_poems/0 returns all poems" do
      poem = poem_fixture()
      assert Poems.list_poems() == [poem]
    end

    test "get_poem!/1 returns the poem with given id" do
      poem = poem_fixture()
      assert Poems.get_poem!(poem.id) == poem
    end

    test "create_poem/1 with valid data creates a poem" do
      assert {:ok, %Poem{} = poem} = Poems.create_poem(@valid_attrs)
      assert poem.content == "some content"
      assert poem.date_for == ~D[2010-04-17]
      assert poem.deleted == true
    end

    test "create_poem/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Poems.create_poem(@invalid_attrs)
    end

    test "update_poem/2 with valid data updates the poem" do
      poem = poem_fixture()
      assert {:ok, %Poem{} = poem} = Poems.update_poem(poem, @update_attrs)
      assert poem.content == "some updated content"
      assert poem.date_for == ~D[2011-05-18]
      assert poem.deleted == false
    end

    test "update_poem/2 with invalid data returns error changeset" do
      poem = poem_fixture()
      assert {:error, %Ecto.Changeset{}} = Poems.update_poem(poem, @invalid_attrs)
      assert poem == Poems.get_poem!(poem.id)
    end

    test "delete_poem/1 deletes the poem" do
      poem = poem_fixture()
      assert {:ok, %Poem{}} = Poems.delete_poem(poem)
      assert_raise Ecto.NoResultsError, fn -> Poems.get_poem!(poem.id) end
    end

    test "change_poem/1 returns a poem changeset" do
      poem = poem_fixture()
      assert %Ecto.Changeset{} = Poems.change_poem(poem)
    end
  end
end
