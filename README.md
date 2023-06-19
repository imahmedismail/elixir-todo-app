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

# Testing

You can run the tests for this application using:

```
mix test
```