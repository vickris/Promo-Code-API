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
    promo = Promo |> Repo.get_by(code: code) |> Repo.preload(event: :location)

    case promo do
      nil ->
        {:error, "Invalid promo supplied"}

      _ ->
        apply_promo(promo, origin, destination)
    end
  end

  def apply_promo(promo, origin, destination) do
    is_valid = check_promo_validity(promo)

    case is_valid do
      {:ok, "valid"} ->
        promo_radius = promo.radius
        event_location = promo.event.location

        radius_origin_to_event =
          GreatCircle.distance(
            {origin.longitude, origin.latitude},
            {event_location.longitude, event_location.latitude}
          ) / 1000

        radius_event_to_destination =
          GreatCircle.distance(
            {event_location.longitude, event_location.latitude},
            {destination.longitude, destination.latitude}
          ) / 1000

        if radius_origin_to_event <= promo_radius || radius_event_to_destination <= promo_radius do
          SafeBoda.update_promo(promo, %{is_deactivated: true})
          {:ok, "Promo code successfully applied"}
        else
          {:error, "Distance not within promo code range"}
        end

      {:error, "deactivated"} ->
        {:error, "Promo has already been applied"}

      {:error, "expired"} ->
        {:error, "Promo has expired"}

      _ ->
        {:error, "Invalid promo supplied"}
    end
  end

  def check_promo_validity(promo) do
    cond do
      promo.is_deactivated -> {:error, "deactivated"}
      promo.expiry_date < Date.utc_today() -> {:error, "expired"}
      true -> {:ok, "valid"}
    end
  end

  def update_promo_radius(promo, radius) do
    SafeBoda.update_promo(promo, %{radius: radius})
  end

  def generate_promo_codes(num, event_id, span_in_days, radius \\ 50.0) do
    date_today = Date.utc_today()

    Enum.each(1..num, fn i ->
      Repo.insert!(%Promo{
        code: CodeGenerator.randomizer(8, :upcase),
        amount: 500,
        event_id: event_id,
        expiry_date: Date.add(date_today, span_in_days),
        radius: radius
      })
    end)
  end
end
