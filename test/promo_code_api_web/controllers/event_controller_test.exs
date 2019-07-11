defmodule PromoCodeApiWeb.EventControllerTest do
  use PromoCodeApiWeb.ConnCase

  alias PromoCodeApi.SafeBoda
  alias PromoCodeApi.SafeBoda.Event

  @create_location_attrs %{latitude: "120.5", longitude: "120.5", name: "some name"}
  @create_attrs %{location_id: 42, name: "some name"}
  @update_attrs %{location_id: 43, name: "some updated name"}
  @invalid_attrs %{location_id: nil, name: nil}

  def fixture(:event, location) do
    {:ok, event} = SafeBoda.create_event(Map.merge(@create_attrs, %{location_id: location.id}))
    event
  end

  def fixture(:location) do
    {:ok, location} = SafeBoda.create_location(@create_location_attrs)
    location
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all events", %{conn: conn} do
      conn = get(conn, event_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create event" do
    test "renders event when data is valid", %{conn: conn} do
      location = fixture(:location)

      conn =
        post(conn, event_path(conn, :create),
          event: Map.merge(@create_attrs, %{location_id: location.id})
        )

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, event_path(conn, :show, id))

      assert json_response(conn, 200)["data"] == %{
               "id" => id,
               "location_id" => SafeBoda.get_event!(id).location_id,
               "name" => "some name"
             }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, event_path(conn, :create), event: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update event" do
    setup [:create_event]

    test "renders event when data is valid", %{conn: conn, event: %Event{id: id} = event} do
      conn =
        put(conn, event_path(conn, :update, event),
          event: Map.merge(@update_attrs, %{location_id: event.location_id})
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, event_path(conn, :show, id))

      assert json_response(conn, 200)["data"] == %{
               "id" => id,
               "location_id" => SafeBoda.get_event!(id).location_id,
               "name" => "some updated name"
             }
    end

    test "renders errors when data is invalid", %{conn: conn, event: event} do
      conn = put(conn, event_path(conn, :update, event), event: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete event" do
    setup [:create_event]

    test "deletes chosen event", %{conn: conn, event: event} do
      conn = delete(conn, event_path(conn, :delete, event))
      assert response(conn, 204)

      assert_error_sent(404, fn ->
        get(conn, event_path(conn, :show, event))
      end)
    end
  end

  defp create_event(_) do
    location = fixture(:location)
    event = fixture(:event, location)
    {:ok, event: event}
  end
end
