defmodule HiveBackend.Repo do
  use Ecto.Repo,
    otp_app: :hive_backend,
    adapter: Ecto.Adapters.Postgres
end
