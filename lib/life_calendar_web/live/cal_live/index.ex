defmodule LifeCalendarWeb.CalLive.Index do
  use LifeCalendarWeb, :live_view

  alias LifeCalendar.Cals
  alias LifeCalendar.Cals.Cal

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :cals, Cals.list_cals_for_user(socket.assigns.current_user.id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Cal")
    |> assign(:cal, Cals.get_cal!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Cal")
    |> assign(:cal, %Cal{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Cals")
    |> assign(:cal, nil)
  end

  @impl true
  def handle_info({LifeCalendarWeb.CalLive.FormComponent, {:saved, cal}}, socket) do
    {:noreply, stream_insert(socket, :cals, cal)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    cal = Cals.get_cal!(id)
    {:ok, _} = Cals.delete_cal(cal)

    {:noreply, stream_delete(socket, :cals, cal)}
  end
end
