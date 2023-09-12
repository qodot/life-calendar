defmodule LifeCalendar.Cals.Period do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cals_periods" do
    field(:name, :string)
    field(:color, :string)
    field(:show?, :boolean, default: true)
    field(:start_year, :integer)
    field(:start_week, :integer)
    field(:end_year, :integer)
    field(:end_week, :integer)
    field(:user_id, :id)

    belongs_to(:cal, LifeCalendar.Cals.Cal)

    timestamps()
  end

  @doc false
  def changeset(period, attrs) do
    period
    |> cast(attrs, [:name, :color, :start_year, :start_week, :end_year, :end_week, :user_id])
    |> validate_required([:name, :color, :start_year, :start_week, :end_year, :end_week, :user_id])
    |> validate_inclusion(:start_week, 1..52)
    |> validate_inclusion(:end_week, 1..52)
  end
end
