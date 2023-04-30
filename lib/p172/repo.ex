defmodule P172.Repo do
  use Ecto.Repo,
    otp_app: :p172,
    adapter: Ecto.Adapters.Postgres
end
