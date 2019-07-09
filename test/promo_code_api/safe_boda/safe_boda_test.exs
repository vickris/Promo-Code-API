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
      assert location.latitude == Decimal.new("120.5")
      assert location.longitude == Decimal.new("120.5")
      assert location.name == "some name"
    end

    test "create_location/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SafeBoda.create_location(@invalid_attrs)
    end

    test "update_location/2 with valid data updates the location" do
      location = location_fixture()
      assert {:ok, location} = SafeBoda.update_location(location, @update_attrs)
      assert %Location{} = location
      assert location.latitude == Decimal.new("456.7")
      assert location.longitude == Decimal.new("456.7")
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

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert SafeBoda.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert SafeBoda.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      assert {:ok, %Event{} = event} = SafeBoda.create_event(@valid_attrs)
      assert event.location_id == 42
      assert event.name == "some name"
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SafeBoda.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      assert {:ok, event} = SafeBoda.update_event(event, @update_attrs)
      assert %Event{} = event
      assert event.location_id == 43
      assert event.name == "some updated name"
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = SafeBoda.update_event(event, @invalid_attrs)
      assert event == SafeBoda.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = SafeBoda.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> SafeBoda.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = SafeBoda.change_event(event)
    end
  end
end
