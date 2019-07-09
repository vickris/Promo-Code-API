defmodule PromoCodeApi.Repo.Migrations.CreateLocations do
  use Ecto.Migration

  def change do
    create table(:locations) do
      add :name, :string
      add :latitude, :decimal
      add :longitude, :decimal

      timestamps()
    end

  end
end
