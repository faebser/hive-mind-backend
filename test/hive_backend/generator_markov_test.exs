defmodule HiveBackend.GeneratorTests.Markov do
	use HiveBackend.DataCase

	alias HiveBackend.Generators.Markov

	describe "markov generator" do
		test "just to see how this works" do
			assert Markov.tokenize("BLA") == [ Markov.start, "bla", Markov.finish ]
		end

		test "simple test" do
			assert Markov.tokenize("BLA\nBLA") == [ Markov.start ,"bla", Markov.newline, "bla", Markov.finish ]
		end

		test "punctuation" do
			assert Markov.tokenize("BLA.\nBLA?;:,.") == [ Markov.start, "bla", ".", Markov.newline, "bla", "?", ";",":",",",".", Markov.finish]
		end

		test "tokenize poem" do
			p = Markov.tokenize "Sit here\nnext to me.\nSit here\nto make us feel.\n\nBake your time\ncalm and wise,\nfor us to realise\nthat it's just now,\nour life."
			assert p == [ Markov.start, "sit", "here", Markov.newline, 
					"next", "to", "me",".", Markov.newline,
					"sit", "here", Markov.newline, "to", "make", "us", 
					"feel", ".", Markov.newline, Markov.newline, "bake", "your", "time",
					Markov.newline, "calm", "and", "wise" , ",", Markov.newline,
					"for", "us", "to", "realise",Markov.newline, 
					"that", "it", "'", "s", "just", "now", ",", Markov.newline, "our", "life", ".",
					Markov.finish
				]
		end

		test "faulty newline at the end" do
			p = "A poem is a poem is the only thing <NEWLINE> is a poem is a poem is a poem is the only thing <NEWLINE>"
			p2 =  p |> Markov.tokens_replace |> Markov.trim_capitalize 
			assert p2 == "A poem is a poem is the only thing \nis a poem is a poem is a poem is the only thing"
		end

		test "prepare model" do
			map = Markov.prepare_model [ Markov.start ,"bla", Markov.newline, "bla", Markov.finish ]

			assert map == %{
					  "<NEWLINE>" => ["bla"],
					  "<START>" => ["bla"],
					  "bla" => ["<FINISH>", "<NEWLINE>"]
					}

		end

		test "move model to agent" do
			{ :ok, pid } = Markov.start_link
			map = Markov.prepare_model [ Markov.start ,"bla", Markov.newline, "bla", Markov.finish ]

			Markov.update_agent map, pid

			newmap = Agent.get(pid, fn state -> state end)

			assert newmap == %{
					  "<NEWLINE>" => ["bla"],
					  "<START>" => ["bla"],
					  "bla" => ["<FINISH>", "<NEWLINE>"]
					}
		end

		test "update model in agent" do
			{ :ok, pid } = Markov.start_link
			map = Markov.prepare_model [ Markov.start ,"bla", Markov.newline, "bla", Markov.finish ]

			Markov.update_agent map, pid

			newmap = Agent.get(pid, fn state -> state end)

			assert newmap == %{
					  "<NEWLINE>" => ["bla"],
					  "<START>" => ["bla"],
					  "bla" => ["<FINISH>", "<NEWLINE>"]
					}

			map2 = Markov.prepare_model [ Markov.start ,"bla", "+", Markov.newline, "bla", Markov.finish ]

			Markov.update_agent map2, pid

			map2get = Agent.get(pid, fn state -> state end)

			assert map2get == %{
	              "<NEWLINE>" => ["bla", "bla"],
	              "<START>" => ["bla", "bla"],
	              "bla" => ["<FINISH>", "<NEWLINE>", "<FINISH>", "+"],
	              "+" => ["<NEWLINE>"]
	            }
		end

		test "generate poem" do
			{ :ok, pid } = Markov.start_link
			Markov.add_poem pid, "BLA\nBLA"

			poem = Markov.generate(pid)

			assert String.contains?(poem, Markov.start) == false
			assert String.contains?(poem, Markov.finish) == false
			assert String.contains?(poem, "bla")
		end

		test "replace tokens in poem" do
			{ :ok, pid } = Markov.start_link
			Markov.add_poem pid, "BLA\nBLA"

			poem = Markov.generate(pid) |> Markov.tokens_replace

			assert String.contains?(poem, Markov.start) == false
			assert String.contains?(poem, Markov.finish) == false
			assert String.contains?(poem, Markov.newline) == false
			assert String.contains?(poem, "bla")
		end

		test "trim and capitalize" do
			{ :ok, pid } = Markov.start_link
			Markov.add_poem pid, "BLA\nBLA"

			poem = Markov.generate(pid) 
			|> Markov.tokens_replace
			|> Markov.trim_capitalize

			
			assert String.starts_with?(poem, " ") == false
			assert String.starts_with?(poem, "B")
		end

		test "test public endpoint" do
			{ :ok, pid } = Markov.start_link
			Markov.add_poem pid, "BLA\nBLA"

			poem = Markov.get(pid)
			
			assert String.starts_with?(poem, " ") == false
			assert String.contains?(poem, Markov.start) == false
			assert String.contains?(poem, Markov.finish) == false
			assert String.contains?(poem, Markov.newline) == false
			assert String.starts_with?(poem, "B")
		end
	end
end