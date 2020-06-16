defmodule HiveBackendWeb.StatsController do
  use HiveBackendWeb, :controller

  import Ecto.Query, warn: false
  alias HiveBackend.Repo
  alias HiveBackend.TodayRequest
  alias HiveBackend.Poems.Theme
  alias HiveBackend.Poems.Poem

  alias HiveBackend.Accounts.User

  # show user that were active in the last days
  # add d3 graphs


  @per_day_query from p in Poem, group_by: p.date_for, select: {p.date_for, count(p.id)}, order_by: [ asc: p.date_for ]

  def get_day_map( poem ) do
    %{
      :date_string => '',
      :date_for => poem.date_for,
      :insert_datetimes => [ poem.inserted_at ],
      :sum => 1
    }
  end

  def update_day_map( day_map, poem ) do
    %{ :insert_datetimes => i_dt, :sum => s} = day_map

    %{ day_map | :sum => s + 1, :insert_datetimes => [ poem.inserted_at | i_dt]}
  end

  def get_user_map( uuid ) do
    %{
      :first_day => ~D[1970-01-01], # date for first poem
      :current_day => ~D[1970-01-01], # date for current poem
      :avg => 0, # average
      :poems => 0, # total amount of poems
      :days => 0, # total amount of days
      :uuid => uuid
    }
  end

  def update_user_map(user_map, poem) do
    %{:first_day => fd, :avg => avg, :poems => p, 
    :days => d, :current_day => cd} = user_map

    { cd, d } = case cd != poem.date_for do
       true  -> { poem.date_for, d + 1 }
       false -> { cd, d }
    end 

    #IO.puts( 'd: #{d}' )
    #IO.puts('p: #{p + 1}, d: #{d}, calculate #{ (p + 1) / d}')

    case fd do
      ~D[1970-01-01] ->
        %{ user_map | :first_day => poem.date_for, :current_day => cd,
                      :poems => p + 1, :days => d, :avg => (p + 1) / d}
      _ -> 
        %{ user_map | :current_day => cd, :poems => p + 1, :days => d,
                      :avg => (p + 1) / d} 
    end
  end


  def stats(conn, _params) do
    # generate one day since first poem with the amount
    # for each user calculate average poems per day since first poem

    users = User |> Repo.all
    poems_with_errors = Poem |> Repo.all( order_by: [ asc: :date_for ] )
    poems = from( Poem, distinct: :content, order_by: [ asc: :date_for ] ) |> Repo.all
    by_day = @per_day_query |> Repo.all

    by_day_avg = length( poems ) / length( by_day )

    user_id_to_uuid = 
    Enum.map( users, fn user -> { user.id, user.user_uuid } end )
    |> Enum.into( %{} )

    # key is user_id, 
    by_user = Enum.reduce(poems, %{}, fn item, acc ->
      id = item.user_id

      acc = case acc do
        # key in map
        %{^id => user_map} -> 
          %{ acc | item.user_id => update_user_map( user_map, item ) }
        # key not in map
        %{} ->
          Map.put(acc, item.user_id, Map.get(user_id_to_uuid, id) |> get_user_map() |> update_user_map( item ) )
      end
    end)
    |> Enum.into( [], fn {k, v} -> v end )
    |> Enum.sort( fn a, b -> a.poems >= b.poems end)

    { _, last, by_day_detail } = poems
    |> Enum.reduce({ ~D[1970-01-01], %{}, [] }, fn item, { current_date, current, acc } -> 
        case current_date != item.date_for do
           false -> # same day
            { current_date, update_day_map( current, item ), acc }
           true -> # different day
            if current != %{} do
              { item.date_for, get_day_map( item ), [ current | acc ] }
            else
              { item.date_for, get_day_map( item ), acc }
            end
        end
      end)

    by_day_detail = [ last | by_day_detail ]

    render(conn, "stats.html", %{ 
      poems_count: length(poems),
      duplicate_poems: length(poems_with_errors), 
      user_count: length(users),
      by_user: by_user,
      by_day: by_day,
      by_day_avg: by_day_avg,
      by_day_detail: by_day_detail
      })
  end

  def today(con, _params) do

  	t = Theme |> Repo.get_by(date_for: Date.utc_today)
  	
  	j = case t do
  		nil -> %TodayRequest{theme_content: "not found", date_for: nil, theme_id: nil } # TODO return a 404 not found
  		_ ->  %TodayRequest{theme_content: t.content, date_for: t.date_for, theme_id: t.id}
  	end

  	# # send to riemann
  	# Riemannx.send_async [
  	# 	service: "today request",
  	# 	metric: System.monotonic_time - start,
  	# 	description: "request duration"
  	# ]

  	# return something here
  	json con, j
  end

  def date(con, %{"date" => date}) do
  	split = String.split(date, "-")

  	{year, split} = List.pop_at(split, 0)
  	{month, split} = List.pop_at(split, 0)
  	{day, split} = List.pop_at(split, 0)

  	year = String.to_integer(year)
  	month = String.to_integer(month)
  	day = String.to_integer(day)

  	d = case Date.new(year, month, day) do
  		{:ok, dd} -> dd
  		{:error, reason} ->
  			con
  			|> put_status(500)
  			|> json(%{error: reason})
  	end

  	t = Theme |> Repo.get_by(date_for: d)

  	j = case t do
  		nil -> %TodayRequest{theme_content: "not found", date_for: nil, theme_id: nil}
  		_ -> %TodayRequest{theme_content: t.content, date_for: t.date_for, theme_id: t.id}
  	end

  	json con, j
  end
end