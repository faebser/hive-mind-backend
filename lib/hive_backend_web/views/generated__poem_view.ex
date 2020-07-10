defmodule HiveBackendWeb.Generated_PoemView do
  use HiveBackendWeb, :view

  def linebreaks( content ) when length(content) == 1 do
  	render( "blank.html", line: hd( content ) )
  end

  def linebreaks( content ) do
  	Enum.reduce( tl( content ), 
  		render( "blank.html", line: hd( content ) ), 
  		fn c, acc ->
  			[ acc | render( "linebreak.html", line: c) ] 
  		end)
  end
end
