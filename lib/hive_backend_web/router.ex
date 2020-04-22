defmodule HiveBackendWeb.Router do
  use HiveBackendWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/poems-admin", HiveBackendWeb do
    pipe_through :browser

    resources "/users", UserController
    resources "/themes", ThemeController
    resources "/inspirations", InspirationsController
    resources "/poems", PoemController

  end

  # Other scopes may use custom stacks.
  scope "/poems/api", HiveBackendWeb do
    pipe_through :api

    get "/today", ApiController, :today
    get "/date/:date", ApiController, :date
    post "/submit", PoemSubmitController, :submit
    get "/new-user", NewUserController, :new
    get "/:uuid", UserController, :get_poems

  end
end
