defmodule PromoCodeApi.SafeBoda.Event do
  use Ecto.Schema
  import Ecto.Changeset


  schema "events" do
    field :name, :string
    timestamps()

    belongs_to :location, PromoCodeApi.SafeBoda.Location
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :location_id])
    |> validate_required([:name, :location_id])
  end
end
