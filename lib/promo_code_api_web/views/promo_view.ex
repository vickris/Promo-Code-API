defmodule PromoCodeApiWeb.PromoView do
  use PromoCodeApiWeb, :view
  alias PromoCodeApiWeb.PromoView

  def render("index.json", %{promos: promos}) do
    %{data: render_many(promos, PromoView, "promo.json")}
  end

  def render("show.json", %{promo: promo}) do
    %{data: render_one(promo, PromoView, "promo.json")}
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
