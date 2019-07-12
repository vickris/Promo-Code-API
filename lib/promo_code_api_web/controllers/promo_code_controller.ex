defmodule PromoCodeApiWeb.PromoCodeController do
  use PromoCodeApiWeb, :controller

  alias PromoCodeApi.SafeBoda
  alias PromoCodeApi.SafeBoda.Promo

  action_fallback(PromoCodeApiWeb.FallbackController)

  def request(conn, %{"destination" => destination, "origin" => origin, "promo" => promo}) do
    origin = SafeBoda.get_location!(origin)
    destination = SafeBoda.get_location!(destination)
    promo = SafeBoda.get_promo!(promo)

    with {:ok, "Promo code successfully applied"} <-
           PromoCodeApi.request_boda(origin, destination, promo.code) do
      conn
      |> put_status(:ok)
      |> put_resp_header("promo", promo_path(conn, :show, promo))
      |> render("show.json", promo: promo)
    end
  end
end
