defmodule PromoCodeApi do
  @moduledoc """
  PromoCodeApi keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  alias PromoCodeApi.Repo
  alias PromoCodeApi.SafeBoda.Promo
  alias Distance.GreatCircle
  alias PromoCodeApi.SafeBoda

  def request_boda(origin, destination, code) do
    promo = Promo |> Repo.get_by!(code: code) |> Repo.preload([event: :location])
    is_valid = check_promo_validity(promo)

    case is_valid do
      {:ok, "valid"} ->
        promo_radius = promo.radius
        event_location = promo.event.location

        radius_origin_to_event = (GreatCircle.distance({origin.longitude, origin.latitude}, {event_location.longitude, event_location.latitude}) / 1000)
        radius_event_to_destination = (GreatCircle.distance({event_location.longitude, event_location.latitude}, {destination.longitude, destination.latitude}) / 1000)

        if radius_origin_to_event <= promo_radius || radius_event_to_destination <= promo_radius do
            SafeBoda.update_promo(promo, %{is_deactivated: true})
            {:ok, "Promo code successfully applied"}
        else
            {:error, "Distance not within promocode range"}
        end
      _             ->
        {:error, "Invalid promo supplied"}
      end
  end


  def check_promo_validity(promo) do
    result = cond do
              promo.is_deactivated -> {:error, "deactivated"}
              promo.is_expired     -> {:error, "expired"}
              true                 -> {:ok, "valid"}
             end
  end
end
