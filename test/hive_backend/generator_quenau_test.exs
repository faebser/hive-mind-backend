defmodule HiveBackend.GeneratorTests.Queneau do
	use HiveBackend.DataCase

	alias HiveBackend.Generators.Queneau
	alias HiveBackend.Poems.Poem

	describe "Queneau generator:" do

		test "poem clean up" do
			p = 
			%{content: "this is a\n poem"}
			|> Queneau.split_lines

			assert p == [ "this is a", "poem"]

		end

		test "one poem" do
			poems =  fn -> [ %{ content: "this is a\n poem" } ] end

			assert poems.() == [%{content: "this is a\n poem"}]

			{ :ok, pid } = Queneau.start_link

			Queneau.add_all_poems pid, poems

			newlist = Agent.get(pid, fn state -> state end)

			assert newlist == [ ["this is a", "poem"] ]
		end

		test "two poems" do
			poems =  fn -> [ %{ content: "this is a\n poem" }, %{ content: "bla is anan\n poem2" } ] end

			{ :ok, pid } = Queneau.start_link

			Queneau.add_all_poems pid, poems

			newlist = Agent.get(pid, fn state -> state end)

			assert newlist == [ ["this is a", "poem"], [ "bla is anan", "poem2" ] ]
		end

		test "split lines" do
			poem = %{ content: "this is a\n poem" }

			p2 = Queneau.split_lines poem

			assert p2 == [ "this is a", "poem" ]
		end

		test "update agent" do
			{:ok, pid } = Queneau.start_link

			[ "this is a", "poem" ]
			|> Queneau.agent_update( pid )

			newlist = Agent.get(pid, fn state -> state end)

			# assert newlist == [ ["this is a", "poem"] ]
			assert newlist == ["this is a", "poem"]
		end

		test "generate poem with length 1" do
			poems =  fn -> [ %{ content: "this is a\n poem" } ] end

			assert poems.() == [%{content: "this is a\n poem"}]

			{ :ok, pid } = Queneau.start_link

			Queneau.add_all_poems pid, poems

			p = Queneau.generate pid, 1

			assert !String.contains? p, "\n"
		end

		test "generate poem with length 5" do
			poems =  fn -> [ %{ content: "this is a\n poem" }, %{ content: "bla is anan\n poem2" } ] end

			{ :ok, pid } = Queneau.start_link

			Queneau.add_all_poems pid, poems

			p = Queneau.generate pid, 5

			assert String.contains? p, "\n"
		end
	end
end