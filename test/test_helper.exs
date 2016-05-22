ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Meep.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Meep.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Meep.Repo)

