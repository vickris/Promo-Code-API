defmodule PromoCodeApiWeb.PromoCodeController do
  use PromoCodeApiWeb, :controller
  alias PromoCodeApi.SafeBoda
  action_fallback(PromoCodeApiWeb.FallbackController)

  def request(conn, %{"destination" => destination, "origin" => origin, "promo" => promo}) do
    origin = SafeBoda.get_location!(origin)
    destination = SafeBoda.get_location!(destination)
    promo = SafeBoda.get_promo!(promo)

    polyline =
      Polyline.encode([
        {origin.longitude, origin.latitude},
        {destination.longitude, destination.latitude}
      ])

    with {:ok, "Promo code successfully applied"} <-
           PromoCodeApi.request_boda(origin, destination, promo.code) do
      conn
      |> put_status(:ok)
      |> put_resp_header("promo", promo_path(conn, :show, promo))
      |> render("show.json", promo: Map.merge(promo, %{polyline: polyline}))
    else
      {:error, "Invalid promo supplied"} ->
        conn
        |> put_status(:unprocessable_entity)
    end
  end

  # def request(conn, %{"destination" => destination, "origin" => origin, "promo" => promo}) do
  #   origin = SafeBoda.get_location!(origin)
  #   destination = SafeBoda.get_location!(destination)
  #   promo = SafeBoda.get_promo!(promo)
  # end
end
