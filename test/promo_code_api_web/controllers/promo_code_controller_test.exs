defmodule PromoCodeApiWeb.PromoCodeControllerTest do
  use PromoCodeApiWeb.ConnCase

  alias PromoCodeApi.SafeBoda.Location
  alias PromoCodeApi.SafeBoda.Promo
  alias PromoCodeApi.SafeBoda.Event
  alias PromoCodeApi.Repo

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "promo usage" do
    test "renders promo info when everything is valid", %{conn: conn} do
      origin =
        Repo.insert!(%Location{
          name: "Kasarani",
          latitude: -1.10972,
          longitude: 37.07692
        })

      destination =
        Repo.insert!(%Location{
          name: "CBD",
          latitude: -1.2833,
          longitude: 36.8167
        })

      event =
        Repo.insert!(%Event{
          name: "Event 1",
          location_id: origin.id
        })

      promo =
        Repo.insert!(%Promo{
          code: "CHRISTOPHERVU12",
          amount: 500,
          event_id: event.id,
          radius: 50.0,
          expiry_date: Date.add(Date.utc_today(), 10)
        })

      conn =
        conn
        |> post(promo_code_path(conn, :request, origin, destination, promo))

      polyline =
        Polyline.encode([
          {origin.longitude, origin.latitude},
          {destination.longitude, destination.latitude}
        ])

      assert json_response(conn, 200)["data"] == %{
               "amount" => 500,
               "code" => "CHRISTOPHERVU12",
               "expiry_date" => Date.to_iso8601(promo.expiry_date),
               "is_deactivated" => false,
               "promo_radius" => 50.0,
               "polyline" => polyline
             }
    end

    # Assert raise
    # assert Expected response
    test "renders error for invalid data", %{conn: conn} do
      origin =
        Repo.insert!(%Location{
          name: "Kasarani",
          latitude: -1.10972,
          longitude: 37.07692
        })

      destination =
        Repo.insert!(%Location{
          name: "CBD",
          latitude: -1.2833,
          longitude: 36.8167
        })

      event =
        Repo.insert!(%Event{
          name: "Event 1",
          location_id: origin.id
        })

      promo =
        Repo.insert!(%Promo{
          code: "CHRISTOPHERVU12",
          amount: 500,
          event_id: event.id,
          radius: 50.0,
          expiry_date: Date.add(Date.utc_today(), 10)
        })

      assert_error_sent(:not_found, fn ->
        conn
        |> post(promo_code_path(conn, :request, 67, destination, 38))
      end)

      # conn = require IEx
      # IEx.pry()
    end
  end
end
