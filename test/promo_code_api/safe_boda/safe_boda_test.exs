defmodule PromoCodeApi.SafeBodaTest do
  use PromoCodeApi.DataCase

  alias PromoCodeApi.SafeBoda

  describe "locations" do
    alias PromoCodeApi.SafeBoda.Location

    @valid_attrs %{latitude: "120.5", longitude: "120.5", name: "some name"}
    @update_attrs %{latitude: "456.7", longitude: "456.7", name: "some updated name"}
    @invalid_attrs %{latitude: nil, longitude: nil, name: nil}

    def location_fixture(attrs \\ %{}) do
      {:ok, location} =
        attrs
        |> Enum.into(@valid_attrs)
        |> SafeBoda.create_location()

      location
    end

    test "list_locations/0 returns all locations" do
      location = location_fixture()
      assert SafeBoda.list_locations() == [location]
    end

    test "get_location!/1 returns the location with given id" do
      location = location_fixture()
      assert SafeBoda.get_location!(location.id) == location
    end

    test "create_location/1 with valid data creates a location" do
      assert {:ok, %Location{} = location} = SafeBoda.create_location(@valid_attrs)
      assert location.latitude == 120.5
      assert location.longitude == 120.5
      assert location.name == "some name"
    end

    test "create_location/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SafeBoda.create_location(@invalid_attrs)
    end

    @tag :wip
    test "update_location/2 with valid data updates the location" do
      location = location_fixture()
      assert {:ok, location} = SafeBoda.update_location(location, @update_attrs)
      assert %Location{} = location
      assert location.latitude == 456.7
      assert location.longitude == 456.7
      assert location.name == "some updated name"
    end

    test "update_location/2 with invalid data returns error changeset" do
      location = location_fixture()
      assert {:error, %Ecto.Changeset{}} = SafeBoda.update_location(location, @invalid_attrs)
      assert location == SafeBoda.get_location!(location.id)
    end

    test "delete_location/1 deletes the location" do
      location = location_fixture()
      assert {:ok, %Location{}} = SafeBoda.delete_location(location)
      assert_raise Ecto.NoResultsError, fn -> SafeBoda.get_location!(location.id) end
    end

    test "change_location/1 returns a location changeset" do
      location = location_fixture()
      assert %Ecto.Changeset{} = SafeBoda.change_location(location)
    end
  end

  describe "events" do
    alias PromoCodeApi.SafeBoda.Event

    @valid_attrs %{location_id: 42, name: "some name"}
    @update_attrs %{location_id: 43, name: "some updated name"}
    @invalid_attrs %{location_id: nil, name: nil}

    def event_fixture(attrs \\ %{}) do
      {:ok, event} =
        attrs
        |> Enum.into(@valid_attrs)
        |> SafeBoda.create_event()

      event
    end

    def event_fixture_with_location(location, attrs \\ %{}) do
      {:ok, event} =
        attrs
        |> Enum.into(Map.merge(@valid_attrs, %{location_id: location.id}))
        |> SafeBoda.create_event()

      event
    end

    test "list_events/0 returns all events" do
      location = location_fixture()
      event = event_fixture_with_location(location)
      assert SafeBoda.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      location = location_fixture()
      event = event_fixture_with_location(location)
      assert SafeBoda.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      location = location_fixture()
      assert {:ok, %Event{} = event} = SafeBoda.create_event(Map.merge(@valid_attrs, %{location_id: location.id}))
      assert event.location_id == location.id
      assert event.name == "some name"
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SafeBoda.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      location = location_fixture()
      event = event_fixture_with_location(location)
      assert {:ok, event} = SafeBoda.update_event(event, Map.merge(@update_attrs, %{location_id: location.id}))
      assert %Event{} = event
      assert event.location_id == location.id
      assert event.name == "some updated name"
    end

    test "update_event/2 with invalid data returns error changeset" do
      location = location_fixture()
      event = event_fixture_with_location(location)
      assert {:error, %Ecto.Changeset{}} = SafeBoda.update_event(event, @invalid_attrs)
      assert event == SafeBoda.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      location = location_fixture()
      event = event_fixture_with_location(location)
      assert {:ok, %Event{}} = SafeBoda.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> SafeBoda.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      location = location_fixture()
      event = event_fixture_with_location(location)
      assert %Ecto.Changeset{} = SafeBoda.change_event(event)
    end
  end

  describe "promos" do
    alias PromoCodeApi.SafeBoda.Promo

    date = ~D[2019-07-10]
    @valid_attrs %{amount: 42, code: "some code", event_id: 42, is_deactivated: true, expiry_date: date, radius: 120.5}
    @update_attrs %{amount: 43, code: "some updated code", event_id: 43, is_deactivated: false, expiry_date: date, radius: 456.7}
    @invalid_attrs %{amount: nil, code: nil, event_id: nil, is_deactivated: nil, expiry_date: nil, radius: nil}

    def promo_fixture(attrs \\ %{}) do
      {:ok, promo} =
        attrs
        |> Enum.into(@valid_attrs)
        |> SafeBoda.create_promo()

      promo
    end

    def promo_fixture_with_event(event, attrs \\ %{}) do
      {:ok, promo} =
        attrs
        |> Enum.into(Map.merge(@valid_attrs, %{event_id: event.id}))
        |> SafeBoda.create_promo()

      promo
    end

    test "list_promos/0 returns all promos" do
      location = location_fixture()
      event = event_fixture_with_location(location)
      promo = promo_fixture_with_event(event)
      assert SafeBoda.list_promos() == [promo]
    end

    test "get_promo!/1 returns the promo with given id" do
      location = location_fixture()
      event = event_fixture_with_location(location)
      promo = promo_fixture_with_event(event)
      assert SafeBoda.get_promo!(promo.id) == promo
    end

    test "create_promo/1 with valid data creates a promo" do
      location = location_fixture()
      event = event_fixture_with_location(location)

      assert {:ok, %Promo{} = promo} = SafeBoda.create_promo(Map.merge(@valid_attrs, %{event_id: event.id}))
      assert promo.amount == 42
      assert promo.code == "some code"
      assert promo.event_id == event.id
      assert promo.is_deactivated == true
      assert promo.radius == 120.5
    end

    test "create_promo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SafeBoda.create_promo(@invalid_attrs)
    end

    test "update_promo/2 with valid data updates the promo" do
      location = location_fixture()
      event = event_fixture_with_location(location)
      promo = promo_fixture_with_event(event)
      assert {:ok, promo} = SafeBoda.update_promo(promo, Map.merge(@update_attrs, %{event_id: event.id}))
      assert %Promo{} = promo
      assert promo.amount == 43
      assert promo.code == "some updated code"
      assert promo.event_id == event.id
      assert promo.is_deactivated == false
      assert promo.radius == 456.7
    end

    test "update_promo/2 with invalid data returns error changeset" do
      location = location_fixture()
      event = event_fixture_with_location(location)
      promo = promo_fixture_with_event(event)
      assert {:error, %Ecto.Changeset{}} = SafeBoda.update_promo(promo, @invalid_attrs)
      assert promo == SafeBoda.get_promo!(promo.id)
    end

    test "delete_promo/1 deletes the promo" do
      location = location_fixture()
      event = event_fixture_with_location(location)
      promo = promo_fixture_with_event(event)
      assert {:ok, %Promo{}} = SafeBoda.delete_promo(promo)
      assert_raise Ecto.NoResultsError, fn -> SafeBoda.get_promo!(promo.id) end
    end

    test "change_promo/1 returns a promo changeset" do
      location = location_fixture()
      event = event_fixture_with_location(location)
      promo = promo_fixture_with_event(event)
      assert %Ecto.Changeset{} = SafeBoda.change_promo(promo)
    end
  end
end
