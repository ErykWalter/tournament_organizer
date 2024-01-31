alias TournamentOrganizer.Accounts
alias TournamentOrganizer.Tournaments
alias TournamentOrganizer.Tournaments.Tournament
alias TournamentOrganizer.Repo
alias TournamentOrganizer.Participations
require Logger

user_password = "UserUser12345"

names = ["John", "Jane", "Jack", "Jill", "James"]
surnames = ["Doe", "Smith", "Johnson", "Williams", "Brown"]

addresses = [
  "Rokietnicka 5, Poznań",
  "Marcelińska 2, Poznań",
  "Meissnera 4e, poznan",
  "Kościuszki 76, Poznań"
]

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
    password: user_password,
    name: "John",
    surname: "Doe"
  })

users =
  for i <- 1..10 do
    case Accounts.register_user(%{
           email: "user#{i}@user.com",
           password: user_password,
           name: "John#{i}",
           surname: "Doe#{i}"
         }) do
      {:ok, user} -> user
      {:error, _} -> nil
    end
  end

tournaments =
  [
    %{
      name: "Chess championship",
      application_deadline: Date.add(Date.utc_today(), 1),
      max_participants: 10,
      start_date: DateTime.add(DateTime.utc_now(), 4, :day),
      user_id: user1.id,
      address: addresses |> Enum.random()
    },
    %{
      name: "Football championship",
      application_deadline: Date.add(Date.utc_today(), 9),
      max_participants: 120,
      start_date: DateTime.add(DateTime.utc_now(), 15, :day),
      user_id: user1.id,
      address: addresses |> Enum.random()
    },
    %{
      name: "Basketball championship",
      application_deadline: Date.add(Date.utc_today(), 3),
      max_participants: 25,
      start_date: DateTime.add(DateTime.utc_now(), 8, :day),
      user_id: user2.id,
      address: addresses |> Enum.random()
    },
    %{
      name: "Tennis championship",
      application_deadline: Date.add(Date.utc_today(), 2),
      max_participants: 10,
      start_date: DateTime.add(DateTime.utc_now(), 7, :day),
      user_id: user1.id,
      address: addresses |> Enum.random()
    },
    %{
      name: "Volleyball championship",
      application_deadline: Date.add(Date.utc_today(), 5),
      max_participants: 10,
      start_date: DateTime.add(DateTime.utc_now(), 7, :day),
      user_id: user2.id,
      address: addresses |> Enum.random()
    },
    %{
      name: "Table tennis championship",
      application_deadline: Date.add(Date.utc_today(), 21),
      max_participants: 2,
      start_date: DateTime.add(DateTime.utc_now(), 31, :day),
      user_id: user1.id,
      address: addresses |> Enum.random()
    },
    %{
      name: "Badminton championship",
      application_deadline: Date.add(Date.utc_today(), 2),
      max_participants: 10,
      start_date: DateTime.add(DateTime.utc_now(), 7, :day),
      user_id: user1.id,
      address: addresses |> Enum.random()
    },
    %{
      name: "Darts championship",
      application_deadline: Date.add(Date.utc_today(), 2),
      max_participants: 10,
      start_date: DateTime.add(DateTime.utc_now(), 7, :day),
      user_id: user1.id,
      address: addresses |> Enum.random()
    },
    %{
      name: "Golf championship",
      application_deadline: Date.add(Date.utc_today(), 2),
      max_participants: 10,
      start_date: DateTime.add(DateTime.utc_now(), 7, :day),
      user_id: user1.id,
      address: addresses |> Enum.random()
    },
    %{
      name: "Cycling championship",
      application_deadline: Date.add(Date.utc_today(), 2),
      max_participants: 10,
      start_date: DateTime.add(DateTime.utc_now(), 14, :day),
      user_id: user1.id,
      address: addresses |> Enum.random()
    },
    %{
      name: "Running championship",
      application_deadline: Date.add(Date.utc_today(), 5),
      max_participants: 100,
      start_date: DateTime.add(DateTime.utc_now(), 14, :day),
      user_id: user1.id,
      address: addresses |> Enum.random()
    },
    %{
      name: "Swimming championship",
      application_deadline: Date.add(Date.utc_today(), 2),
      max_participants: 20,
      start_date: DateTime.add(DateTime.utc_now(), 7, :day),
      user_id: user1.id,
      address: addresses |> Enum.random()
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

# Create a tournaments for which deadline has passed
past_event = %Tournament{
  name: "Tournament with deadline passed",
  application_deadline: Date.add(Date.utc_today(), -1),
  max_participants: 10,
  start_date: DateTime.truncate(DateTime.add(DateTime.utc_now(), 7, :day), :second),
  user_id: user1.id
}

past_event = Repo.insert!(past_event)

Participations.create_participation(%{
  user_id: "#{user1.id}",
  tournament_id: "#{past_event.id}",
  licence_number: "1234567890",
  ranking: 1
})

Participations.create_participation(%{
  user_id: user2.id,
  tournament_id: past_event.id,
  licence_number: "qwerty",
  ranking: 2
})

Participations.create_participation(%{
  user_id: Enum.random(users).id,
  tournament_id: past_event.id,
  licence_number: "asdfgh",
  ranking: 3
})
