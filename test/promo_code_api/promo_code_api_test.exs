defmodule PromoCodeApi.PromoCodeApiTest do
  use PromoCodeApi.DataCase

  alias PromoCodeApi.SafeBoda
  alias PromoCodeApi.SafeBoda.Location

  date = Date.add(Date.utc_today(), 20)

  @create_attrs %{
    amount: 42,
    code: "some code",
    event_id: 42,
    is_deactivated: false,
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

  @valid_attrs_location %{latitude: -1.10972, longitude: 37.07692, name: "some name"}
  @valid_attrs_event %{location_id: 42, name: "some name"}

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

  describe "promo" do
    setup [:create_location]

    test "valid_ones_accepted", %{location: %Location{id: id} = origin} do
      event = fixture(:event, origin)
      promo = fixture(:promo, event)

      destination =
        Repo.insert!(%Location{
          name: "CBD",
          latitude: -1.2833,
          longitude: 36.8167
        })

      assert {:ok, "Promo code successfully applied"} ==
               PromoCodeApi.request_boda(origin, destination, promo.code)
    end

    test "deactivated_ones_not_applicable", %{location: %Location{id: id} = origin} do
      event = fixture(:event, origin)
      promo = fixture(:promo, event)

      destination =
        Repo.insert!(%Location{
          name: "CBD",
          latitude: -1.2833,
          longitude: 36.8167
        })

      PromoCodeApi.request_boda(origin, destination, promo.code)

      assert {:error, "Promo has already been applied"} ==
               PromoCodeApi.request_boda(origin, destination, promo.code)
    end

    test "expired_ones_dont_work", %{location: %Location{id: id} = origin} do
      event = fixture(:event, origin)
      promo = fixture(:promo, event)

      SafeBoda.update_promo(promo, %{expiry_date: Date.add(promo.expiry_date, -22)})

      destination =
        Repo.insert!(%Location{
          name: "CBD",
          latitude: -1.2833,
          longitude: 36.8167
        })

      assert {:error, "Promo has expired"} ==
               PromoCodeApi.request_boda(origin, destination, promo.code)
    end

    test "invalid_ones_dont_work", %{location: %Location{id: id} = origin} do
      event = fixture(:event, origin)
      promo = fixture(:promo, event)

      SafeBoda.update_promo(promo, %{code: "KFKDKD"})

      destination =
        Repo.insert!(%Location{
          name: "CBD",
          latitude: -1.2833,
          longitude: 36.8167
        })

      assert {:error, "Invalid promo supplied"} ==
               PromoCodeApi.request_boda(origin, destination, promo.code)
    end

    test "does_not_work_outside_allowed_radius", %{location: %Location{id: id} = origin} do
      event = fixture(:event, origin)
      promo = fixture(:promo, event)

      SafeBoda.update_promo(promo, %{radius: 2.0})

      origin =
        Repo.insert!(%Location{
          name: "CBD",
          latitude: -1.2833,
          longitude: 36.8167
        })

      destination =
        Repo.insert!(%Location{
          name: "Thika",
          latitude: -1.0333,
          longitude: 37.0693
        })

      assert {:error, "Distance not within promo code range"} ==
               PromoCodeApi.request_boda(origin, destination, promo.code)
    end
  end

  setup [:create_location]

  test "promo_code_radius_can_be_updated", %{location: %Location{id: id} = origin} do
    event = fixture(:event, origin)
    promo = fixture(:promo, event)

    original_radius = promo.radius
    {:ok, promo} = PromoCodeApi.update_promo_radius(promo, 2.0)

    assert promo.radius != original_radius
  end

  defp create_event(location) do
    event = fixture(:event, location)
    {:ok, event: event}
  end

  defp create_location(_) do
    location = fixture(:location)
    {:ok, location: location}
  end

  defp create_promo(event) do
    promo = fixture(:promo, event)
    {:ok, promo: promo}
  end
end
