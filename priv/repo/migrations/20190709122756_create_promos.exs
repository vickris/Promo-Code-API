defmodule PromoCodeApi.Repo.Migrations.CreatePromos do
  use Ecto.Migration

  def change do
    create table(:promos) do
      add :code, :string
      add :amount, :integer
      add :event_id, references(:events)
      add :is_expired, :boolean, default: false, null: false
      add :is_deactivated, :boolean, default: false, null: false
      add :radius, :float

      timestamps()
    end

  end
end
