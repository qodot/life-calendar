defmodule LifeCalendarWeb.CalLive.Show do
  use LifeCalendarWeb, :live_view

  alias Ecto
  alias LifeCalendar.Cals
  alias LifeCalendar.Cals.Cal

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    try do
      cal = Cals.get_cal!(id)

      if cal.user_id != socket.assigns.current_user.id do
        raise "NoPermissionError"
      end

      {:noreply,
       socket
       |> assign(:page_title, page_title(socket.assigns.live_action, cal))
       |> assign(:cal, cal)
       |> assign(:years, cal |> Cal.years())}
    rescue
      Ecto.NoResultsError ->
        socket |> redirect_to_cals()

      e in RuntimeError ->
        case e.message do
          "NoPermissionError" -> socket |> redirect_to_cals()
        end
    end
  end

  defp redirect_to_cals(socket) do
    {:noreply,
     socket
     |> put_flash(:error, "존재하지 않는 캘린더입니다.")
     |> push_patch(to: "/cals")}
  end

  defp page_title(:show, cal), do: cal.name
  defp page_title(:edit, cal), do: "#{cal.name} 수정"
end
