defmodule HiveBackend.TodayRequest do
	@derive Jason.Encoder
	defstruct theme_content: "", date_for: nil, theme_id: nil 
end