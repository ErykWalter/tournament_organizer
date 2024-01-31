defmodule TournamentOrganizer.MatchesTest do
  use TournamentOrganizer.DataCase

  alias TournamentOrganizer.Matches

  describe "matches" do
    alias TournamentOrganizer.Matches.Match

    import TournamentOrganizer.MatchesFixtures

    @invalid_attrs %{score1: nil, score2: nil, abs_score: nil}

    test "list_matches/0 returns all matches" do
      match = match_fixture()
      assert Matches.list_matches() == [match]
    end

    test "get_match!/1 returns the match with given id" do
      match = match_fixture()
      assert Matches.get_match!(match.id) == match
    end

    test "create_match/1 with valid data creates a match" do
      valid_attrs = %{score1: true, score2: true, abs_score: 42}

      assert {:ok, %Match{} = match} = Matches.create_match(valid_attrs)
      assert match.score1 == true
      assert match.score2 == true
      assert match.abs_score == 42
    end

    test "create_match/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Matches.create_match(@invalid_attrs)
    end

    test "update_match/2 with valid data updates the match" do
      match = match_fixture()
      update_attrs = %{score1: false, score2: false, abs_score: 43}

      assert {:ok, %Match{} = match} = Matches.update_match(match, update_attrs)
      assert match.score1 == false
      assert match.score2 == false
      assert match.abs_score == 43
    end

    test "update_match/2 with invalid data returns error changeset" do
      match = match_fixture()
      assert {:error, %Ecto.Changeset{}} = Matches.update_match(match, @invalid_attrs)
      assert match == Matches.get_match!(match.id)
    end

    test "delete_match/1 deletes the match" do
      match = match_fixture()
      assert {:ok, %Match{}} = Matches.delete_match(match)
      assert_raise Ecto.NoResultsError, fn -> Matches.get_match!(match.id) end
    end

    test "change_match/1 returns a match changeset" do
      match = match_fixture()
      assert %Ecto.Changeset{} = Matches.change_match(match)
    end
  end
end
