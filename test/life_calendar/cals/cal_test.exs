defmodule LifeCalendar.Cals.CalTest do
  use LifeCalendar.DataCase

  alias LifeCalendar.Cals.Cal

  describe "Cal.deathday" do
    test "사망일을 반환한다" do
      cal = %Cal{birthday: ~D[1988-06-21], lifespan: 80}
      assert cal |> Cal.deathday() == ~D[2068-06-21]
    end
  end

  describe "Cal.total_days_in_life" do
    test "삶의 총 일수를 반환한다" do
      cal = %Cal{birthday: ~D[1988-06-21], lifespan: 80}
      # 윤년 더해주기
      assert cal |> Cal.total_days_in_life() == 365 * 80 + 80 / 4
    end
  end

  describe "Cal.passed_days_in_life" do
    test "특정 날짜 기준 삶의 지나간 일수를 반환한다" do
      cal = %Cal{birthday: ~D[1988-06-21], lifespan: 80}
      assert cal |> Cal.passed_days_in_life(~D[2023-01-03]) == 12614
    end
  end

  describe "Cal.passed_days_ratio_in_life" do
    test "특정 날짜 기준 삶의 남은 일수 비율을 반환한다" do
      cal = %Cal{birthday: ~D[1988-06-21], lifespan: 80}
      assert cal |> Cal.passed_days_ratio_in_life(~D[2023-01-03]) == 43.2
    end
  end

  describe "Cal.total_days_in_year" do
    test "특정 연도의 총 일수를 반환한다" do
      cal = %Cal{birthday: ~D[1988-06-21], lifespan: 80}
      assert Date.utc_today().year |> Cal.total_days_in_year() == 365
    end
  end

  describe "Cal.passed_days_in_year" do
    test "특정 날짜 기준 해당 연도의 지나간 일수를 반환한다" do
      cal = %Cal{birthday: ~D[1988-06-21], lifespan: 80}
      assert ~D[2023-01-03] |> Cal.passed_days_in_year() == 3
    end
  end

  describe "Cal.passed_days_ratio_in_year" do
    test "특정 날짜 기준 해당 연도의 남은 일수 비율을 반환한다" do
      cal = %Cal{birthday: ~D[1988-06-21], lifespan: 80}
      assert ~D[2023-01-08] |> Cal.passed_days_ratio_in_year() == 2.2
    end
  end

  describe "Cal.years" do
    test "Year 구조체의 목록을 반환한다" do
      lifespan = 80
      cal = %Cal{birthday: ~D[1988-06-21], lifespan: lifespan}

      years = cal |> Cal.years()
      assert years |> length() == lifespan + 1

      first_year = years |> Enum.at(0)
      assert first_year.year == 1988

      first_week_of_first_year = first_year.weeks |> Enum.at(0)
      assert first_week_of_first_year.time_type == :before_born

      last_week_of_first_year = first_year.weeks |> Enum.at(-1)
      assert last_week_of_first_year.time_type == :past

      today_year = years |> Enum.at(Date.utc_today().year - 1988)
      assert today_year.year == Date.utc_today().year

      first_week_of_today_year = today_year.weeks |> Enum.at(0)
      assert first_week_of_today_year.time_type == :past

      last_week_of_today_year = today_year.weeks |> Enum.at(-1)
      assert last_week_of_today_year.time_type == :future

      last_year = years |> Enum.at(-1)
      assert last_year.year == 1988 + lifespan

      first_week_of_last_year = last_year.weeks |> Enum.at(0)
      assert first_week_of_last_year.time_type == :old

      last_week_of_last_year = last_year.weeks |> Enum.at(-1)
      assert last_week_of_last_year.time_type == :after_death
    end
  end
end
