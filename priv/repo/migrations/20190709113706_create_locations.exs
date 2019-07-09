defmodule PromoCodeApi.Repo.Migrations.CreateLocations do
  use Ecto.Migration

  def change do
    create table(:locations) do
      add :name, :string
      add :latitude, :float
      add :longitude, :float

      timestamps()
    end

  end
end
