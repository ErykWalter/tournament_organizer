defmodule TournamentOrganizer.ParticipationsTest do
  use TournamentOrganizer.DataCase

  alias TournamentOrganizer.Participations

  describe "participations" do
    alias TournamentOrganizer.Participations.Participation

    import TournamentOrganizer.ParticipationsFixtures

    @invalid_attrs %{ranking: nil, licence_number: nil}

    test "list_participations/0 returns all participations" do
      participation = participation_fixture()
      assert Participations.list_participations() == [participation]
    end

    test "get_participation!/1 returns the participation with given id" do
      participation = participation_fixture()
      assert Participations.get_participation!(participation.id) == participation
    end

    test "create_participation/1 with valid data creates a participation" do
      valid_attrs = %{ranking: 42, licence_number: "some licence_number"}

      assert {:ok, %Participation{} = participation} =
               Participations.create_participation(valid_attrs)

      assert participation.ranking == 42
      assert participation.licence_number == "some licence_number"
    end

    test "create_participation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Participations.create_participation(@invalid_attrs)
    end

    test "update_participation/2 with valid data updates the participation" do
      participation = participation_fixture()
      update_attrs = %{ranking: 43, licence_number: "some updated licence_number"}

      assert {:ok, %Participation{} = participation} =
               Participations.update_participation(participation, update_attrs)

      assert participation.ranking == 43
      assert participation.licence_number == "some updated licence_number"
    end

    test "update_participation/2 with invalid data returns error changeset" do
      participation = participation_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Participations.update_participation(participation, @invalid_attrs)

      assert participation == Participations.get_participation!(participation.id)
    end

    test "delete_participation/1 deletes the participation" do
      participation = participation_fixture()
      assert {:ok, %Participation{}} = Participations.delete_participation(participation)

      assert_raise Ecto.NoResultsError, fn ->
        Participations.get_participation!(participation.id)
      end
    end

    test "change_participation/1 returns a participation changeset" do
      participation = participation_fixture()
      assert %Ecto.Changeset{} = Participations.change_participation(participation)
    end
  end
end
