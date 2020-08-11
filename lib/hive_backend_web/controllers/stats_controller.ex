defmodule HiveBackendWeb.StatsController do
  use HiveBackendWeb, :controller

  import Ecto.Query, warn: false
  alias HiveBackend.Repo
  alias HiveBackend.TodayRequest
  alias HiveBackend.Poems.Theme
  alias HiveBackend.Poems.Poem
  alias HiveBackend.Poems

  alias HiveBackend.Accounts.User

  alias HiveBackend.Generators

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

    seven_days = Date.add( Date.utc_today, -7)
    users = User |> Repo.all
    poems_with_errors = Poem |> Repo.all( order_by: [ asc: :date_for ] )
    poems = Poems.get_distinct_poems
    by_day = @per_day_query |> Repo.all

    last_7_days = Repo.all from p in Poem, distinct: p.content, where: p.date_for > ^seven_days, select: p.user_id
    last_7_days_user_ids = last_7_days |> MapSet.new |> Enum.into([])
    last_7_days_user = Repo.all from u in User, where: u.id in ^last_7_days_user_ids

    by_day_avg = length( poems ) / length( by_day )

    no_rating = Generators.get_all_poems_with_no_rating
    good_rating = Generators.get_all_poems_with_good_rating()
    bad_rating = Generators.get_all_poems_with_bad_rating()

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
      by_day_detail: by_day_detail,
      last_7_days_user: last_7_days_user,
      l_good_rating: length( good_rating ),
      l_bad_rating: length( bad_rating ),
      l_no_rating: length( no_rating ),
      })
  end
end