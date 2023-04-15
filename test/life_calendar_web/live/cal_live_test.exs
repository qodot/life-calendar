defmodule LifeCalendarWeb.CalLiveTest do
  use LifeCalendarWeb.ConnCase

  import Phoenix.LiveViewTest
  import LifeCalendar.CalsFixtures
  import LifeCalendar.AccountsFixtures

  @create_attrs %{birthday: "2023-04-14", lifespan: 42, name: "some name"}
  @update_attrs %{birthday: "2023-04-15", lifespan: 43, name: "some updated name"}
  @invalid_attrs %{birthday: nil, lifespan: nil, name: nil}

  defp create_cal(_) do
    cal = cal_fixture()
    %{cal: cal}
  end

  describe "Index" do
    setup [:create_cal]

    test "lists all cals", %{conn: conn, cal: cal} do
      {:ok, _index_live, html} = conn |> log_in_user(user_fixture()) |> live(~p"/cals")

      assert html =~ "Listing Cals"
      assert html =~ cal.name
    end

    test "saves new cal", %{conn: conn} do
      {:ok, index_live, _html} = conn |> log_in_user(user_fixture()) |> live(~p"/cals")

      assert index_live |> element("a", "New Cal") |> render_click() =~
               "New Cal"

      assert_patch(index_live, ~p"/cals/new")

      assert index_live
             |> form("#cal-form", cal: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#cal-form", cal: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/cals")

      html = render(index_live)
      assert html =~ "Cal created successfully"
      assert html =~ "some name"
    end

    test "updates cal in listing", %{conn: conn, cal: cal} do
      {:ok, index_live, _html} = conn |> log_in_user(user_fixture()) |> live(~p"/cals")

      assert index_live |> element("#cals-#{cal.id} a", "Edit") |> render_click() =~
               "Edit Cal"

      assert_patch(index_live, ~p"/cals/#{cal}/edit")

      assert index_live
             |> form("#cal-form", cal: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#cal-form", cal: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/cals")

      html = render(index_live)
      assert html =~ "Cal updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes cal in listing", %{conn: conn, cal: cal} do
      {:ok, index_live, _html} = conn |> log_in_user(user_fixture()) |> live(~p"/cals")

      assert index_live |> element("#cals-#{cal.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#cals-#{cal.id}")
    end
  end

  describe "Show" do
    setup [:create_cal]

    test "displays cal", %{conn: conn, cal: cal} do
      {:ok, _show_live, html} = conn |> log_in_user(user_fixture()) |> live(~p"/cals/#{cal}")

      assert html =~ "Show Cal"
      assert html =~ cal.name
    end

    test "updates cal within modal", %{conn: conn, cal: cal} do
      {:ok, show_live, _html} = conn |> log_in_user(user_fixture()) |> live(~p"/cals/#{cal}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Cal"

      assert_patch(show_live, ~p"/cals/#{cal}/show/edit")

      assert show_live
             |> form("#cal-form", cal: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#cal-form", cal: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/cals/#{cal}")

      html = render(show_live)
      assert html =~ "Cal updated successfully"
      assert html =~ "some updated name"
    end
  end
end
