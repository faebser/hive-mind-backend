defmodule HiveBackendWeb.Plugs.CheckParams do
	import Plug.Conn

	defmodule IncompleteRequestError do
    	@moduledoc """
    	Error raised when a required field is missing.
    	"""

    	defexception [:message, :plug_status]


    	def exception(value) do
    		msg = "Missing: #{inspect value}"
    		%IncompleteRequestError{message: msg, plug_status: 400}
  		end
  	end

	def init(options) do
		options
	end

	def call(con, opts) do
		missing = check_for_fields con.params, opts[:fields]

		case length(missing) do
			0 -> con
			_ -> raise(IncompleteRequestError, missing)
		end
	end

	def check_for_fields(params, fields) do
		errors = Enum.reduce(fields, [], fn(field, rest) ->
			case Map.has_key?(params, field) do
				true -> rest
				false -> [field] ++ rest
			end
		end)
	end
end