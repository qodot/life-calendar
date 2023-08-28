defmodule LifeCalendarWeb.CalLive.FormComponent do
  use LifeCalendarWeb, :live_component

  alias LifeCalendar.Cals

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>달력 정보를 입력합니다.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="cal-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="이름" />
        <.input field={@form[:birthday]} type="date" label="생일" />
        <.input field={@form[:lifespan]} type="number" label="예상 수명" />

        <:actions>
          <.button phx-disable-with="저장 중...">저장</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{cal: cal} = assigns, socket) do
    changeset = Cals.change_cal(cal)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"cal" => cal_params}, socket) do
    new_cal_params = cal_params |> cal_params_default_birthday()

    changeset =
      socket.assigns.cal
      |> Cals.change_cal(new_cal_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  @impl true
  def handle_event("save", %{"cal" => cal_params}, socket) do
    save_cal(socket, socket.assigns.action, cal_params)
  end

  defp cal_params_default_birthday(cal_params) do
    case cal_params |> Map.get("birthday") do
      "" -> cal_params |> Map.put("birthday", Date.utc_today() |> Calendar.strftime("%Y-%m-%d"))
      _ -> cal_params
    end
  end

  defp cal_params_user_id(cal_params, socket) do
    cal_params |> Map.put("user_id", socket.assigns.current_user.id)
  end

  defp save_cal(socket, :edit, cal_params) do
    new_cal_params = cal_params |> cal_params_default_birthday()

    case Cals.update_cal(socket.assigns.cal, new_cal_params) do
      {:ok, cal} ->
        notify_parent({:saved, cal})

        {:noreply,
         socket
         |> put_flash(:info, "변경 완료")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_cal(socket, :new, cal_params) do
    new_cal_params = cal_params |> cal_params_default_birthday() |> cal_params_user_id(socket)

    case socket.assigns.current_user.id |> Cals.list_cals_for_user() |> length do
      0 ->
        case Cals.create_cal(new_cal_params) do
          {:ok, cal} ->
            notify_parent({:saved, cal})

            {:noreply,
             socket
             |> put_flash(:info, "생성 완료")
             |> push_patch(to: socket.assigns.patch)}

          {:error, %Ecto.Changeset{} = changeset} ->
            {:noreply, assign_form(socket, changeset)}
        end

      _ ->
        {:noreply,
         socket
         |> put_flash(:error, "무료 플랜에서는 하나의 달력만 만들 수 있습니다.")
         |> push_patch(to: socket.assigns.patch)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
