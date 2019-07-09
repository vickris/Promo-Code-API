# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :promo_code_api,
  ecto_repos: [PromoCodeApi.Repo]

# Configures the endpoint
config :promo_code_api, PromoCodeApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "oBmbcdIQv/ERs+5tC4KtA+sHHf3NK7WIKwcqy5EGfo6wHE3ABRU5Jfr8tKu+iY+7",
  render_errors: [view: PromoCodeApiWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: PromoCodeApi.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
