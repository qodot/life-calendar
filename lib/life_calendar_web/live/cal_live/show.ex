defmodule LifeCalendarWeb.CalLive.Show do
  use LifeCalendarWeb, :live_view

  alias LifeCalendar.Cals

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:cal, Cals.get_cal!(id))}
  end

  defp page_title(:show), do: "Show Cal"
  defp page_title(:edit), do: "Edit Cal"
end
