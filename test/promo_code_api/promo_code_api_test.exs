defmodule PromoCodeApi.PromoCodeApiTest do
  use PromoCodeApi.DataCase

  alias PromoCodeApi.SafeBoda

  # Valid promo returns right tuple
  # Deactivated promo does not work
  # Expired promo does nit work
  # Promo doesnt work out of range radius

  test "one_plus_one" do
    assert 1 + 1 == 2
  end

  date = ~D[2019-07-10]

  @create_attrs %{
    amount: 42,
    code: "some code",
    event_id: 42,
    is_deactivated: true,
    expiry_date: date,
    radius: 120.5
  }
  @update_attrs %{
    amount: 43,
    code: "some updated code",
    event_id: 43,
    is_deactivated: false,
    expiry_date: date,
    radius: 456.7
  }
  @invalid_attrs %{
    amount: nil,
    code: nil,
    event_id: nil,
    is_deactivated: nil,
    expiry_date: nil,
    radius: nil
  }

  @valid_attrs_location %{latitude: "120.5", longitude: "120.5", name: "some name"}
  @valid_attrs_event %{location_id: 42, name: "some name"}

  describe "promos" do
    setup
  end

  def fixture(:promo, event) do
    {:ok, promo} = SafeBoda.create_promo(Map.merge(@create_attrs, %{event_id: event.id}))
    promo
  end

  def fixture(:event, location) do
    {:ok, promo} =
      SafeBoda.create_event(Map.merge(@valid_attrs_event, %{location_id: location.id}))

    promo
  end

  def fixture(:location) do
    {:ok, promo} = SafeBoda.create_location(@valid_attrs_location)
    promo
  end

  defp create_event(location) do
    event = fixture(:event)
    {:ok, event: event}
  end

  defp create_location(_) do
    event = fixture(:event)
    {:ok, event: event}
  end

  defp create_promo(event) do
    event = fixture(:event)
    {:ok, event: event}
  end
end
