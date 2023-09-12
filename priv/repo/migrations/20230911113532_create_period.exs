defmodule LifeCalendar.Repo.Migrations.CreatePeriod do
  use Ecto.Migration

  def change do
    create table(:cals_periods) do
      add :name, :string
      add :color, :string
      add :show?, :boolean
      add :start_year, :integer
      add :start_week, :integer
      add :end_year, :integer
      add :end_week, :integer
      add :cal_id, references(:cals, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:cals_periods, [:user_id])
  end
end
