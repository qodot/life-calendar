defmodule LifeCalendar.CalsTest do
  use LifeCalendar.DataCase

  alias LifeCalendar.Cals

  describe "cals" do
    alias LifeCalendar.Cals.Cal

    import LifeCalendar.CalsFixtures
    import LifeCalendar.AccountsFixtures

    @invalid_attrs %{birthday: nil, lifespan: nil, name: nil}

    test "list_cals/0 returns all cals" do
      cal = cal_fixture()
      assert Cals.list_cals() == [cal]
    end

    test "get_cal!/1 returns the cal with given id" do
      cal = cal_fixture()
      assert Cals.get_cal!(cal.id) == cal
    end

    test "create_cal/1 with valid data creates a cal" do
      user = user_fixture()
      valid_attrs = %{birthday: ~D[2023-04-14], lifespan: 42, name: "some name", user_id: user.id}

      assert {:ok, %Cal{} = cal} = Cals.create_cal(valid_attrs)
      assert cal.birthday == ~D[2023-04-14]
      assert cal.lifespan == 42
      assert cal.name == "some name"
    end

    test "create_cal/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Cals.create_cal(@invalid_attrs)
    end

    test "update_cal/2 with valid data updates the cal" do
      cal = cal_fixture()
      update_attrs = %{birthday: ~D[2023-04-15], lifespan: 43, name: "some updated name"}

      assert {:ok, %Cal{} = cal} = Cals.update_cal(cal, update_attrs)
      assert cal.birthday == ~D[2023-04-15]
      assert cal.lifespan == 43
      assert cal.name == "some updated name"
    end

    test "update_cal/2 with invalid data returns error changeset" do
      cal = cal_fixture()
      assert {:error, %Ecto.Changeset{}} = Cals.update_cal(cal, @invalid_attrs)
      assert cal == Cals.get_cal!(cal.id)
    end

    test "delete_cal/1 deletes the cal" do
      cal = cal_fixture()
      assert {:ok, %Cal{}} = Cals.delete_cal(cal)
      assert_raise Ecto.NoResultsError, fn -> Cals.get_cal!(cal.id) end
    end

    test "change_cal/1 returns a cal changeset" do
      cal = cal_fixture()
      assert %Ecto.Changeset{} = Cals.change_cal(cal)
    end
  end
end
