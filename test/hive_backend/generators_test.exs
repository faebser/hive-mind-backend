defmodule HiveBackend.GeneratorsTest do
  use HiveBackend.DataCase

  alias HiveBackend.Generators

  describe "generated_poems" do
    alias HiveBackend.Generators.Generated_Poem

    @valid_attrs %{content: "some content", from: 42, status: 42}
    @update_attrs %{content: "some updated content", from: 43, status: 43}
    @invalid_attrs %{content: nil, from: nil, status: nil}

    def generated__poem_fixture(attrs \\ %{}) do
      {:ok, generated__poem} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Generators.create_generated__poem()

      generated__poem
    end

    test "list_generated_poems/0 returns all generated_poems" do
      generated__poem = generated__poem_fixture()
      assert Generators.list_generated_poems() == [generated__poem]
    end

    test "get_generated__poem!/1 returns the generated__poem with given id" do
      generated__poem = generated__poem_fixture()
      assert Generators.get_generated__poem!(generated__poem.id) == generated__poem
    end

    test "create_generated__poem/1 with valid data creates a generated__poem" do
      assert {:ok, %Generated_Poem{} = generated__poem} = Generators.create_generated__poem(@valid_attrs)
      assert generated__poem.content == "some content"
      assert generated__poem.from == 42
      assert generated__poem.status == 42
    end

    test "create_generated__poem/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Generators.create_generated__poem(@invalid_attrs)
    end

    test "update_generated__poem/2 with valid data updates the generated__poem" do
      generated__poem = generated__poem_fixture()
      assert {:ok, %Generated_Poem{} = generated__poem} = Generators.update_generated__poem(generated__poem, @update_attrs)
      assert generated__poem.content == "some updated content"
      assert generated__poem.from == 43
      assert generated__poem.status == 43
    end

    test "update_generated__poem/2 with invalid data returns error changeset" do
      generated__poem = generated__poem_fixture()
      assert {:error, %Ecto.Changeset{}} = Generators.update_generated__poem(generated__poem, @invalid_attrs)
      assert generated__poem == Generators.get_generated__poem!(generated__poem.id)
    end

    test "delete_generated__poem/1 deletes the generated__poem" do
      generated__poem = generated__poem_fixture()
      assert {:ok, %Generated_Poem{}} = Generators.delete_generated__poem(generated__poem)
      assert_raise Ecto.NoResultsError, fn -> Generators.get_generated__poem!(generated__poem.id) end
    end

    test "change_generated__poem/1 returns a generated__poem changeset" do
      generated__poem = generated__poem_fixture()
      assert %Ecto.Changeset{} = Generators.change_generated__poem(generated__poem)
    end
  end
end
