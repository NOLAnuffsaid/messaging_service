defmodule MessagingServiceWeb.Router do
  use MessagingServiceWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", MessagingServiceWeb do
    pipe_through :api
  end

  scope "/hooks", MessagingServiceWeb do
    pipe_through :api

    post "/sms", MessageController, :send_sms
  end
end
