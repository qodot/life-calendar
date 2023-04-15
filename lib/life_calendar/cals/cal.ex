defmodule LifeCalendar.Cals.Cal do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cals" do
    field :birthday, :date
    field :lifespan, :integer
    field :name, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(cal, attrs) do
    cal
    |> cast(attrs, [:name, :birthday, :lifespan])
    |> validate_required([:name, :birthday, :lifespan])
  end
end
