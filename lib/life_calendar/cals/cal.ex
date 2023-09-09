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

  defp age(birthday) do
    case birthday do
      nil ->
        1

      _ ->
        Date.utc_today().year - (birthday |> Date.from_iso8601!()).year
    end
  end

  @spec deathday(Cal.t()) :: Date.t()
  def deathday(cal) do
    {:ok, day} = Date.new(cal.birthday.year + cal.lifespan, cal.birthday.month, cal.birthday.day)
    day
  end

  @spec total_days_in_life(Cal.t()) :: integer
  def total_days_in_life(cal) do
    Date.diff(cal |> deathday(), cal.birthday)
  end

  @spec passed_days_in_life(Cal.t(), Date.t()) :: integer
  def passed_days_in_life(cal, date) do
    Date.diff(date, cal.birthday)
  end

  @spec passed_days_ratio_in_life(Cal.t(), Date.t()) :: float
  def passed_days_ratio_in_life(cal, date) do
    (passed_days_in_life(cal, date) / total_days_in_life(cal) * 100) |> Float.round(1)
  end

  @spec total_days_in_year(integer) :: integer
  def total_days_in_year(year) do
    {:ok, first} = Date.new(year, 1, 1)
    {:ok, last} = Date.new(year, 12, 31)
    Date.diff(last, first) + 1
  end

  @spec passed_days_in_year(Date.t()) :: integer
  def passed_days_in_year(date) do
    {:ok, first} = Date.new(date.year, 1, 1)
    Date.diff(date, first) + 1
  end

  @spec passed_days_ratio_in_year(Date.t()) :: float
  def passed_days_ratio_in_year(date) do
    (passed_days_in_year(date) / total_days_in_year(date.year) * 100) |> Float.round(1)
  end

  defmodule Year do
    defstruct [:year, :weeks]
  end

  defmodule Week do
    defstruct [:year, :week, :time_type]
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
            create_week(
              year,
              week,
              today_year,
              today_week_number,
              cal.birthday.year,
              birthday_week_number,
              cal.lifespan
            )
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

  defp create_week(
         year,
         week,
         today_year,
         today_week_number,
         birthday_year,
         birthday_week_number,
         lifespan
       ) do
    %Week{
      year: year,
      week: week,
      time_type:
        time_type(
          year,
          week,
          today_year,
          today_week_number,
          birthday_year,
          birthday_week_number,
          lifespan
        )
    }
  end

  defp time_type(
         year,
         week,
         today_year,
         today_week_number,
         birthday_year,
         birthday_week_number,
         lifespan
       ) do
    this_year? = today_year == year
    born_year? = birthday_year == year
    last_year = birthday_year + lifespan
    last_year? = last_year == year
    old_year = last_year - lifespan / 10 - 1
    old_year? = old_year == year
    after_old_year? = old_year < year

    before_born? = born_year? && birthday_week_number > week

    past? =
      today_year > year ||
        (this_year? && today_week_number > week)

    now? = this_year? && today_week_number == week
    after_death? = last_year? && week >= birthday_week_number
    old? = (old_year? && week >= birthday_week_number) || after_old_year?

    case {before_born?, past?, now?, after_death?, old?} do
      {true, true, false, false, false} -> :before_born
      {false, true, false, false, _} -> :past
      {false, false, true, false, _} -> :now
      {false, false, false, false, false} -> :future
      {false, false, false, true, _} -> :after_death
      {false, false, false, false, true} -> :old
    end
  end
end
