defmodule PromoCodeApiWeb.PromoCodeView do
  use PromoCodeApiWeb, :view
  alias PromoCodeApiWeb.PromoCodeView

  def render("show.json", %{promo: promo}) do
    %{data: render_one(promo, PromoCodeView, "promo.json", as: :promo)}
  end

  def render("promo.json", %{promo: promo}) do
    %{
      code: promo.code,
      amount: promo.amount,
      expiry_date: promo.expiry_date,
      is_deactivated: promo.is_deactivated,
      promo_radius: promo.radius,
      polyline: promo.polyline
    }
  end
end
