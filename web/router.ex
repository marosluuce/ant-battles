defmodule AntBattles.Router do
  use AntBattles.Web, :router

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

  scope "/", AntBattles do
    pipe_through :browser

    get "/", AntController, :index
  end

  scope "/api", AntBattles do
    pipe_through :api


    get "/join/:team", AntController, :join
    get "/:nest_id/spawn", AntController, :spawn
    get "/:ant_id/look", AntController, :look
    get "/:ant_id/move/:direction", AntController, :move
    get "/:id/info", AntController, :info
  end
end
