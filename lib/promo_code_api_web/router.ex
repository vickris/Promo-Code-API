defmodule PromoCodeApiWeb.Router do
  use PromoCodeApiWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", PromoCodeApiWeb do
    pipe_through(:api)

    resources("/locations", LocationController)
    resources("/events", EventController)
    resources("/promos", PromoController, except: [:new, :edit])
    post("/request-boda/:origin/:destination/:promo", PromoCodeController, :request)
    get("/request-boda/:origin/:destination/:promo", PromoCodeController, :show)
  end
end
