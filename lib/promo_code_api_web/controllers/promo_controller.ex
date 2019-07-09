defmodule PromoCodeApiWeb.PromoController do
  use PromoCodeApiWeb, :controller

  alias PromoCodeApi.SafeBoda
  alias PromoCodeApi.SafeBoda.Promo

  action_fallback PromoCodeApiWeb.FallbackController

  def index(conn, _params) do
    promos = SafeBoda.list_promos()
    render(conn, "index.json", promos: promos)
  end

  def create(conn, %{"promo" => promo_params}) do
    with {:ok, %Promo{} = promo} <- SafeBoda.create_promo(promo_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", promo_path(conn, :show, promo))
      |> render("show.json", promo: promo)
    end
  end

  def show(conn, %{"id" => id}) do
    promo = SafeBoda.get_promo!(id)
    render(conn, "show.json", promo: promo)
  end

  def update(conn, %{"id" => id, "promo" => promo_params}) do
    promo = SafeBoda.get_promo!(id)

    with {:ok, %Promo{} = promo} <- SafeBoda.update_promo(promo, promo_params) do
      render(conn, "show.json", promo: promo)
    end
  end

  def delete(conn, %{"id" => id}) do
    promo = SafeBoda.get_promo!(id)
    with {:ok, %Promo{}} <- SafeBoda.delete_promo(promo) do
      send_resp(conn, :no_content, "")
    end
  end
end
