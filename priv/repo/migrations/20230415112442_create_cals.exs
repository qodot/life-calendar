defmodule LifeCalendar.Repo.Migrations.CreateCals do
  use Ecto.Migration

  def change do
    create table(:cals) do
      add :name, :string
      add :birthday, :date
      add :lifespan, :integer
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:cals, [:user_id])
  end
end
