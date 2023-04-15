defmodule LifeCalendar.CalsFixtures do
  import LifeCalendar.AccountsFixtures

  @moduledoc """
  This module defines test helpers for creating
  entities via the `LifeCalendar.Cals` context.
  """

  @doc """
  Generate a cal.
  """
  def cal_fixture(attrs \\ %{}) do
    user = user_fixture()

    {:ok, cal} =
      attrs
      |> Enum.into(%{
        birthday: ~D[2023-04-14],
        lifespan: 42,
        name: "some name",
        user_id: user.id
      })
      |> LifeCalendar.Cals.create_cal()

    cal
  end
end
