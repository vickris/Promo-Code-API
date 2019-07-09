defmodule PromoCodeApi.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :name, :string
      add :location_id, references(:locations)

      timestamps()
    end

  end
end
