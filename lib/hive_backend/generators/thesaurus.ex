defmodule HiveBackend.Generators.Thesaurus do

	alias HiveBackend.Poems

	use Tesla, only: [ :get ]

	@key Application.compile_env( :hive_backend, :thesaurus_key )

	plug Tesla.Middleware.BaseUrl, "https://www.dictionaryapi.com/api/v3/references/thesaurus/json"
  	plug Tesla.Middleware.JSON


	def tokenize(text) do
		text
			|> String.downcase
			#|> String.replace( ~r/([[:punct:]])/, fn to_replace -> " #{ to_replace } " end)
			#|> String.replace( ~r{\n}, " #{ @newline } ")
			|> String.split
	end

	def generate( poem ) do

		tokens = poem |> tokenize
		
		result =
		0..5
		|> Enum.reduce(nil, fn _, acc ->

			case acc do
				{ :ok, index, value } -> 
					{ :ok, index, value }
				_ -> 

					index = Enum.random(0..length( tokens ) - 1)

					syn =
					tokens
					|> Enum.at( index )
					|> get_from_api
					|> unpack_syns

					case syn do
						{ :ok, value } ->
							IO.puts "found syn: #{ value }"
							{ :ok, index, value }
						{ :error, reason } ->
							IO.puts "got error: #{ reason }"
							{ :error, reason }
					end
			end
		end)

		case result do
			{ :ok, index, syn } ->
				p = 
				tokens
				|> List.replace_at( index, syn )
				|> Enum.join(" ")
				|> trim_capitalize

				{ :ok, p }
			x -> x 
		end
	end

	def get_from_api( token ) do
		case get("/" <> token, query: [ key: @key ]) do
			 { :ok, response } -> get_syn_from_response response.body
			 { :error, _ } -> { :error, "http error" }
		end
	end

	def get_syn_from_response( response_body ) when length(response_body) == 0 do
		{ :error, "no result" }
	end

	def get_syn_from_response( response_body ) when is_list(response_body) do
		case hd( response_body ) do
			 %{ "meta" => meta } -> 
			 	%{ "syns" => syns } = meta
			 	{ :ok, syns }
			 _ -> { :error, "no meta" }
		end
	end

	def get_syn_from_response( response_body ) do
		{ :error, response_body }
	end

	def unpack_syns( { :ok, syns } ) do
		[ [ syn | _ ] | _ ] = syns
		{ :ok, syn }
	end

	def unpack_syns( error ) do
		error
	end

	def trim_capitalize(poem) do
		p = 
		poem
		|> String.trim
		
		s =
		p
		|> String.first
		|> String.capitalize

		s <> String.slice(p, 1..-1)
	end
end