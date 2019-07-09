defmodule PromoCodeApiWeb.Router do
  use PromoCodeApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PromoCodeApiWeb do
    pipe_through :api

    resources "/locations", LocationController
    resources "/events", EventController
    resources "/promos", PromoController, except: [:new, :edit]
  end
end
