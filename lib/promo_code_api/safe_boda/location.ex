defmodule PromoCodeApi.SafeBoda.Location do
  use Ecto.Schema
  import Ecto.Changeset


  schema "locations" do
    field :latitude, :decimal
    field :longitude, :decimal
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(location, attrs) do
    location
    |> cast(attrs, [:name, :latitude, :longitude])
    |> validate_required([:name, :latitude, :longitude])
  end
end
