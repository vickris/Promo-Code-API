defmodule PromoCodeApiWeb.LocationController do
  use PromoCodeApiWeb, :controller

  alias PromoCodeApi.SafeBoda
  alias PromoCodeApi.SafeBoda.Location

  action_fallback PromoCodeApiWeb.FallbackController

  def index(conn, _params) do
    locations = SafeBoda.list_locations()
    render(conn, "index.json", locations: locations)
  end

  def create(conn, %{"location" => location_params}) do
    with {:ok, %Location{} = location} <- SafeBoda.create_location(location_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", location_path(conn, :show, location))
      |> render("show.json", location: location)
    end
  end

  def show(conn, %{"id" => id}) do
    location = SafeBoda.get_location!(id)
    render(conn, "show.json", location: location)
  end

  def update(conn, %{"id" => id, "location" => location_params}) do
    location = SafeBoda.get_location!(id)

    with {:ok, %Location{} = location} <- SafeBoda.update_location(location, location_params) do
      render(conn, "show.json", location: location)
    end
  end

  def delete(conn, %{"id" => id}) do
    location = SafeBoda.get_location!(id)
    with {:ok, %Location{}} <- SafeBoda.delete_location(location) do
      send_resp(conn, :no_content, "")
    end
  end
end
