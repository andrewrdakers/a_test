defmodule Affiliate.Router do
  use Affiliate.Web, :router
  use Coherence.Router         # Add this

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Affiliate do
    pipe_through :browser # Use the default browser stack
    get "/", PageController, :index
  end

  scope "/", Affiliate do
    pipe_through :protected # Use the default browser stack

    resources "/products", ProductController
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session  # Add this
  end

  pipeline :protected do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session, protected: true
  end

  # Add this block
  scope "/" do
    pipe_through :browser
    coherence_routes()
  end

  # Add this block
  scope "/" do
    pipe_through :protected
    coherence_routes :protected
  end
end
