defmodule HiveBackend.Generators.Queneau do

	alias HiveBackend.Poems
	alias HiveBackend.Generators.Markov

	# get all poems
	# split by lines
	# generate poems

	def start_link, do: Agent.start_link(fn -> [] end)

	def add_all_poems(pid, poems) do
		poems.()
		|> Enum.map( &split_lines/1 )
		|> agent_update( pid )
	end

	def split_lines( full_poem ) do
		String.split( full_poem.content, "\n" )
		|> Enum.map( &String.trim/1 )
	end

	def agent_update( poems, pid ) do
		Agent.update(pid, fn state ->
			state ++ poems
		end)
	end

	def generate( pid, max_size ) do
		# get poems
		# get random poem
		# take first line
		# get random poem, take i-th line
		# until it is last line in poem

		poems_lines = Agent.get pid, fn state -> state end

		result = 
		poems_lines
		|> r_generate( 0, max_size, [] , [])
		|> Enum.join( "\n" )
		|> Markov.trim_capitalize

		result
	end

	def r_generate( _poems, _index, 0, _last, acc) do
		acc
	end

	def r_generate( poems, index, size, last, acc ) do

		filtered_poems =
		poems |> Enum.filter( fn poem -> length(poem) > index end )

		case length( filtered_poems ) do
			 0 -> r_generate poems, index, 0, last, acc
			 _ -> 
			 	p = Enum.random( filtered_poems )
				
				r_generate( poems, index + 1, size - 1, p, [ Enum.fetch!( p, index ) | acc ] ) 
		end

	end
end