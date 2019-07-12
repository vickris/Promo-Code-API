defmodule PromoCodeApiWeb.PromoCodeView do
  use PromoCodeApiWeb, :view
  alias PromoCodeApiWeb.PromoCodeView

  def render("show.json", %{promo: promo}) do
    %{data: render_one(promo, PromoCodeView, "promo.json", as: :promo)}
  end

  def render("promo.json", %{promo: promo}) do
    %{
      id: promo.id,
      code: promo.code,
      amount: promo.amount,
      code: promo.code,
      event_id: promo.event_id,
      expiry_date: promo.expiry_date,
      is_deactivated: promo.is_deactivated,
      radius: promo.radius
    }
  end
end
