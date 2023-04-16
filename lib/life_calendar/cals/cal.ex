defmodule LifeCalendar.Cals.Cal do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cals" do
    field(:birthday, :date)
    field(:lifespan, :integer)
    field(:name, :string)
    field(:user_id, :id)

    timestamps()
  end

  @doc false
  def changeset(cal, attrs) do
    cal
    |> cast(attrs, [:name, :birthday, :lifespan, :user_id])
    |> validate_required([:name, :birthday, :lifespan, :user_id])
    |> validate_inclusion(:lifespan, (attrs["birthday"] |> age)..120)
  end

  defmodule Year do
    defstruct [:year, :weeks]
  end

  defmodule Week do
    defstruct [:year, :week, :time_type]
  end

  defp age(birthday) do
    case birthday do
      nil ->
        1

      _ ->
        Date.utc_today().year - (birthday |> Date.from_iso8601!()).year
    end
  end

  @spec years(Cal.t()) :: [Year.t()]
  def years(cal) do
    today_year = Date.utc_today().year
    today_week_number = Date.utc_today() |> week_number()
    birthday_week_number = cal.birthday |> week_number()

    cal
    |> years_range()
    |> Enum.map(fn year ->
      %Year{
        year: year,
        weeks:
          1..52
          |> Enum.map(fn week ->
            create_week(year, week, today_year, today_week_number, birthday_week_number)
          end)
      }
    end)
  end

  defp week_number(date) do
    {date.year, date.month, date.day} |> :calendar.iso_week_number() |> elem(1)
  end

  defp years_range(cal) do
    cal.birthday.year..(cal.birthday.year + cal.lifespan)
  end

  defp create_week(year, week, today_year, today_week_number, _birthday_week_number) do
    now? = today_year == year && today_week_number == week

    past? =
      today_year > year ||
        (today_year == year && today_week_number > week)

    time_type = if now?, do: :now, else: if(past?, do: :past, else: :future)

    %Week{
      year: year,
      week: week,
      time_type: time_type
    }
  end
end
