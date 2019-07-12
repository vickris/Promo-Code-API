defmodule PromoCodeApiWeb.PromoCodeControllerTest do
  use PromoCodeApiWeb.ConnCase

  alias PromoCodeApi.SafeBoda
  alias PromoCodeApi.SafeBoda.Location
  alias PromoCodeApi.SafeBoda.Promo
  alias PromoCodeApi.SafeBoda.Event
  alias PromoCodeApi.Repo

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "promo usage", %{conn: conn} do
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
      |> post(promo_code_path(conn, :request, origin, destination, promo),
        request_params: %{origin: origin, destination: destination, promo: promo}
      )

    assert json_response(conn, 200)["data"] == %{
             "amount" => 500,
             "code" => "CHRISTOPHERVU12",
             "event_id" => event.id,
             "expiry_date" => "2019-07-22",
             "id" => promo.id,
             "is_deactivated" => false,
             "radius" => 50.0
           }
  end
end
