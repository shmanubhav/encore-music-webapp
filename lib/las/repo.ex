defmodule Las.Repo do
  use Ecto.Repo,
    otp_app: :las,
    adapter: Ecto.Adapters.Postgres
end
