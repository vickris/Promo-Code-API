defmodule PromoCodeApi.SafeBoda.Promo do
  use Ecto.Schema
  import Ecto.Changeset


  schema "promos" do
    field :amount, :integer
    field :code, :string
    field :is_deactivated, :boolean, default: false
    field :is_expired, :boolean, default: false
    field :radius, :float
    timestamps()

    belongs_to :Event, PromoCodeApi.SafeBoda.Event
  end

  @doc false
  def changeset(promo, attrs) do
    promo
    |> cast(attrs, [:code, :amount, :event_id, :is_expired, :is_deactivated, :radius])
    |> validate_required([:code, :amount, :event_id, :is_expired, :is_deactivated, :radius])
  end
end
