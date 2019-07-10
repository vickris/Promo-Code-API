defmodule PromoCodeApi.Repo.Migrations.PromosAddExpiryDate do
  use Ecto.Migration

  def change do
    alter table(:promos) do
      add :expiry_date, :date
      remove :is_expired
    end
  end
end
