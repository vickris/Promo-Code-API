defmodule PromoCodeApi.SafeBoda.Promo do
  use Ecto.Schema
  import Ecto.Changeset


  schema "promos" do
    field :amount, :integer
    field :code, :string
    field :is_deactivated, :boolean, default: false
    field :expiry_date, :date
    field :radius, :float
    timestamps()

    belongs_to :event, PromoCodeApi.SafeBoda.Event
  end

  @doc false
  def changeset(promo, attrs) do
    promo
    |> cast(attrs, [:code, :amount, :event_id, :expiry_date, :is_deactivated, :radius])
    |> validate_required([:code, :amount, :event_id, :expiry_date, :is_deactivated, :radius])
  end
end
