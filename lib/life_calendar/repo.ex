defmodule LifeCalendar.Repo do
  use Ecto.Repo,
    otp_app: :life_calendar,
    adapter: Ecto.Adapters.Postgres
end
