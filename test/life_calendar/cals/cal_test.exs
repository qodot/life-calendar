defmodule LifeCalendar.Cals.CalTest do
  use LifeCalendar.DataCase

  alias LifeCalendar.Cals.Cal

  describe "Cal.years" do
    test "returns a list of Year" do
      lifespan = 80
      cal = %Cal{birthday: ~D[1988-06-21], lifespan: lifespan}

      years = cal |> Cal.years()
      assert years |> length() == lifespan + 1

      first_year = years |> Enum.at(0)
      assert first_year.year == 1988

      first_week_of_first_year = first_year.weeks |> Enum.at(0)
      assert first_week_of_first_year.past? == true

      today_year = years |> Enum.at(Date.utc_today().year - 1988)
      assert today_year.year == Date.utc_today().year

      first_week_of_today_year = today_year.weeks |> Enum.at(0)
      assert first_week_of_first_year.past? == true

      last_week_of_today_year = today_year.weeks |> Enum.at(-1)
      assert last_week_of_today_year.past? == false
    end
  end
end
