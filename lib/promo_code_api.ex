defmodule PromoCodeApi do
  @moduledoc """
  PromoCodeApi keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def request_boda(origin, destination, code) do
    Distance.GreatCircle.distance({origin.longitude, origin.latitude}, {destination.longitude, destination.latitude})
  end
end
