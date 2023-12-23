alias TournamentOrganizer.Accounts
alias TournamentOrganizer.Tournaments

# Create a user
{:ok, user} =
  Accounts.register_user(%{
    email: "admin@admin.com",
    password: "AdminAdmin123",
    name: "admin",
    surname: "admin"
  })

# Create a tournament
for tournament <- ["Chess championship", "Football championship", "Basketball championship"] do
  {:ok, _} =
    Tournaments.create_tournament(%{
      name: tournament,
      application_deadline: Date.add(Date.utc_today(), 2),
      max_participants: 10,
      start_date: DateTime.add(DateTime.utc_now(), 7, :day),
      user_id: user.id
    })
end
