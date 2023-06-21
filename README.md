# Application Introduction

Its a test-task, name of the application is ElixirTodoApp, the main functionalities of this app are as follows:

 - List CRUD API
 - Item CRUD API
 - List/Item Web UI with API implementation

# Setup

Install the following versions of tools mentioned:
```
elixir          1.14.5-otp-26
erlang          26.0 
nodejs          20.2.0 
```

Compile the application via:
```
mix deps.get
mix ecto.create
mix ecto.migrate
```

# Running the App

If you're done with the above mentioned steps successfully you'll be able to run the project using:
```
mix phx.server
```

# Routes to visit

These are the browser-routes available to test the APIs:

```
GET     /todo/list                          ElixirTodoAppWeb.ListLive.Index :index
GET     /todo/list/new                      ElixirTodoAppWeb.ListLive.Index :new
GET     /todo/list/:id/edit                 ElixirTodoAppWeb.ListLive.Index :edit
GET     /todo/list/:id                      ElixirTodoAppWeb.ListLive.Show :show
GET     /todo/list/:id/show/edit            ElixirTodoAppWeb.ListLive.Show :edit
GET     /todo/list/:id/item/new             ElixirTodoAppWeb.ListLive.Show :new_item
GET     /todo/list/:id/item/edit            ElixirTodoAppWeb.ListLive.Show :edit_item
```

# Testing

You can run the tests for this application using:

```
mix test
```