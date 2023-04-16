defmodule LifeCalendarWeb.CalLive.Show do
  use LifeCalendarWeb, :live_view

  alias LifeCalendar.Cals
  alias LifeCalendar.Cals.Cal

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    cal = Cals.get_cal!(id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action, cal))
     |> assign(:cal, cal)
     |> assign(:years, cal |> Cal.years())}
  end

  defp page_title(:show, cal), do: cal.name
  defp page_title(:edit, cal), do: "#{cal.name} 수정"
end
