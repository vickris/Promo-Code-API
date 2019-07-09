defmodule PromoCodeApiWeb.PromoControllerTest do
  use PromoCodeApiWeb.ConnCase

  alias PromoCodeApi.SafeBoda
  alias PromoCodeApi.SafeBoda.Promo

  @create_attrs %{amount: 42, code: "some code", event_id: 42, is_deactivated: true, is_expired: true, radius: 120.5}
  @update_attrs %{amount: 43, code: "some updated code", event_id: 43, is_deactivated: false, is_expired: false, radius: 456.7}
  @invalid_attrs %{amount: nil, code: nil, event_id: nil, is_deactivated: nil, is_expired: nil, radius: nil}

  def fixture(:promo) do
    {:ok, promo} = SafeBoda.create_promo(@create_attrs)
    promo
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all promos", %{conn: conn} do
      conn = get conn, promo_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create promo" do
    test "renders promo when data is valid", %{conn: conn} do
      conn = post conn, promo_path(conn, :create), promo: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, promo_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "amount" => 42,
        "code" => "some code",
        "event_id" => 42,
        "is_deactivated" => true,
        "is_expired" => true,
        "radius" => 120.5}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, promo_path(conn, :create), promo: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update promo" do
    setup [:create_promo]

    test "renders promo when data is valid", %{conn: conn, promo: %Promo{id: id} = promo} do
      conn = put conn, promo_path(conn, :update, promo), promo: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, promo_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "amount" => 43,
        "code" => "some updated code",
        "event_id" => 43,
        "is_deactivated" => false,
        "is_expired" => false,
        "radius" => 456.7}
    end

    test "renders errors when data is invalid", %{conn: conn, promo: promo} do
      conn = put conn, promo_path(conn, :update, promo), promo: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete promo" do
    setup [:create_promo]

    test "deletes chosen promo", %{conn: conn, promo: promo} do
      conn = delete conn, promo_path(conn, :delete, promo)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, promo_path(conn, :show, promo)
      end
    end
  end

  defp create_promo(_) do
    promo = fixture(:promo)
    {:ok, promo: promo}
  end
end
