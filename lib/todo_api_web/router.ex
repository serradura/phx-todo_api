defmodule TodoApiWeb.Router do
  use TodoApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TodoApiWeb do
    pipe_through :api
  end
end
