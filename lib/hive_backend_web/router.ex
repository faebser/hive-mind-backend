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

  scope "/poem-admin/", HiveBackendWeb do
    pipe_through :browser

    resources "/users", UserController
    resources "/themes", ThemeController
    resources "/inspirations", InspirationsController
    resources "/poems", PoemController


    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/poems/api", HiveBackendWeb do
    pipe_through :api

    get "/today", ApiController, :today
    post "/submit", PoemSubmitController, :submit

  end
end
