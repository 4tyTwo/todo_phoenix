defmodule TodoWeb.Router do
  use TodoWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", TodoWeb do
    pipe_through :api

    resources "/users", UserController, only: [:create, :index]
  end
end
