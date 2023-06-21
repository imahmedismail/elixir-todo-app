defmodule ElixirTodoAppWeb.Router do
  use ElixirTodoAppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ElixirTodoAppWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ElixirTodoAppWeb do
    pipe_through :api

    resources "/lists", ListController do
      resources "/items", ItemController
    end
  end

  scope "/todo", ElixirTodoAppWeb do
    pipe_through :browser

    get "/", TodoController, :index
    live "/list", ListLive.Index, :index
    live "/list/new", ListLive.Index, :new
    live "/list/:id/edit", ListLive.Index, :edit

    live "/list/:id", ListLive.Show, :show
    live "/list/:id/show/edit", ListLive.Show, :edit
    live "/list/:id/item/new", ListLive.Show, :new_item
    live "/list/:id/item/edit", ListLive.Show, :edit_item
  end

  # Other scopes may use custom stacks.
  # scope "/api", ElixirTodoAppWeb do
  #   pipe_through :api
  # end

  # Enable Swoosh mailbox preview in development
  if Application.compile_env(:elixir_todo_app, :dev_routes) do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
