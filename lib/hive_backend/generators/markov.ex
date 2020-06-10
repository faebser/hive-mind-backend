defmodule HiveBackend.Generators.Markov do

	# add punctuation (, . 's)
	# add start and end

	@newline "<NEWLINE>"
	@start "<START>"
	@finish "<FINISH>"

	def newline do
		@newline
	end

	def start do
		@start
	end

	def finish do
		@finish
	end

	def tokenize(text) do
		text
			|> String.downcase
			|> String.replace( ~r/([[:punct:]])/, fn to_replace -> " #{ to_replace } " end)
			|> String.replace( ~r{\n}, " #{ @newline } ")
			|> String.split
			|> List.insert_at( 0, @start )
			|> List.insert_at( -1, @finish)
	end

	def start_link, do: Agent.start_link(fn -> %{} end) # create map for sharing through agent

	# map in agent
	# keys are words

	def add_poem(pid, poem) do
		poem
		|> tokenize
		|> prepare_model
		|> update_agent(pid)
	end

	# make pairs
	# use reduce to do that
	# use map.merge/3
	# extend list on conflict

	def prepare_model(tokens) do
		{ _, map } 
		= tl( tokens )
		|> Enum.reduce( { hd( tokens ), %{} }, fn token, { previous_token, acc } ->
			# IO.puts "previous token: #{ previous_token }, token: #{ token }"
			already = acc[ previous_token ] || []
			acc = Map.put acc, previous_token, [ token | already ]
			{ token, acc }
		end)

		map
	end

	def update_agent(map, pid) do
		Agent.update(pid, fn state ->
			Map.merge(state, map, fn key, v1, v2 ->
				v1 ++ v2
			end)
		end)
	end

	def get(pid) do
		pid
		|> generate
		|> tokens_replace
		|> trim_capitalize
	end

	def generate(pid) do
		state = Agent.get(pid, fn state -> state end)

		r_generate @start, state, "", 0
	end

	# recursive function
	# runs until end or full stop.
	# carries next_token, state, poem, length (kind of a timeout)

	# base case
	def r_generate(@finish, state, poem, size) do
		poem
	end

	# start case
	def r_generate(@start, state, poem, size) do
		next_token = Enum.random state[ @start ]

		r_generate next_token, state, poem, size + 1
	end

	# normal case
	def r_generate(current_token, state, poem, size) do
		next_token = Enum.random state[ current_token ]
		poem = poem <> " " <> current_token

		r_generate next_token, state, poem, size + 1
	end

	def tokens_replace(poem) do
		# replaces token while also removing additional white space
		poem
		|> String.replace( @newline <> " ", "\n")
	end

	def trim_capitalize(poem) do
		poem
		|> String.trim
		|> String.capitalize
	end
end