alias TournamentOrganizer.Accounts
alias TournamentOrganizer.Tournaments

{:ok, user1} =
  Accounts.register_user(%{
    email: "admin@admin.com",
    password: "AdminAdmin123",
    name: "admin",
    surname: "admin"
  })

{:ok, user2} =
  Accounts.register_user(%{
    email: "user@user.com",
    password: "UserUser12345",
    name: "John",
    surname: "Doe"
  })

tournaments =
  [
    %{
      name: "Chess championship",
      application_deadline: Date.add(Date.utc_today(), 1),
      max_participants: 10,
      start_date: DateTime.add(DateTime.utc_now(), 4, :day),
      user_id: user1.id
    },
    %{
      name: "Football championship",
      application_deadline: Date.add(Date.utc_today(), 9),
      max_participants: 120,
      start_date: DateTime.add(DateTime.utc_now(), 15, :day),
      user_id: user1.id
    },
    %{
      name: "Basketball championship",
      application_deadline: Date.add(Date.utc_today(), 3),
      max_participants: 25,
      start_date: DateTime.add(DateTime.utc_now(), 8, :day),
      user_id: user2.id
    },
    %{
      name: "Tennis championship",
      application_deadline: Date.add(Date.utc_today(), 2),
      max_participants: 10,
      start_date: DateTime.add(DateTime.utc_now(), 7, :day),
      user_id: user1.id
    },
    %{
      name: "Volleyball championship",
      application_deadline: Date.add(Date.utc_today(), 5),
      max_participants: 10,
      start_date: DateTime.add(DateTime.utc_now(), 7, :day),
      user_id: user2.id
    },
    %{
      name: "Table tennis championship",
      application_deadline: Date.add(Date.utc_today(), 21),
      max_participants: 2,
      start_date: DateTime.add(DateTime.utc_now(), 31, :day),
      user_id: user1.id
    },
    %{
      name: "Badminton championship",
      application_deadline: Date.add(Date.utc_today(), 2),
      max_participants: 10,
      start_date: DateTime.add(DateTime.utc_now(), 7, :day),
      user_id: user1.id
    },
    %{
      name: "Darts championship",
      application_deadline: Date.add(Date.utc_today(), 2),
      max_participants: 10,
      start_date: DateTime.add(DateTime.utc_now(), 7, :day),
      user_id: user1.id
    },
    %{
      name: "Golf championship",
      application_deadline: Date.add(Date.utc_today(), 2),
      max_participants: 10,
      start_date: DateTime.add(DateTime.utc_now(), 7, :day),
      user_id: user1.id
    },
    %{
      name: "Cycling championship",
      application_deadline: Date.add(Date.utc_today(), 2),
      max_participants: 10,
      start_date: DateTime.add(DateTime.utc_now(), 14, :day),
      user_id: user1.id
    },
    %{
      name: "Running championship",
      application_deadline: Date.add(Date.utc_today(), 5),
      max_participants: 100,
      start_date: DateTime.add(DateTime.utc_now(), 14, :day),
      user_id: user1.id
    },
    %{
      name: "Swimming championship",
      application_deadline: Date.add(Date.utc_today(), 2),
      max_participants: 20,
      start_date: DateTime.add(DateTime.utc_now(), 7, :day),
      user_id: user1.id
    }
  ]

# Create a tournament
for tournament <- tournaments do
  {:ok, _} =
    Tournaments.create_tournament(%{
      name: tournament.name,
      application_deadline: tournament.application_deadline,
      max_participants: tournament.max_participants,
      start_date: tournament.start_date,
      user_id: tournament.user_id
    })
end
