defmodule TournamentOrganizerWeb.ParticipationControllerTest do
  use TournamentOrganizerWeb.ConnCase

  import TournamentOrganizer.ParticipationsFixtures

  @create_attrs %{ranking: 42, licence_number: "some licence_number"}
  @update_attrs %{ranking: 43, licence_number: "some updated licence_number"}
  @invalid_attrs %{ranking: nil, licence_number: nil}

  describe "index" do
    test "lists all participations", %{conn: conn} do
      conn = get(conn, ~p"/participations")
      assert html_response(conn, 200) =~ "Listing Participations"
    end
  end

  describe "new participation" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/participations/new")
      assert html_response(conn, 200) =~ "New Participation"
    end
  end

  describe "create participation" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/participations", participation: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/participations/#{id}"

      conn = get(conn, ~p"/participations/#{id}")
      assert html_response(conn, 200) =~ "Participation #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/participations", participation: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Participation"
    end
  end

  describe "edit participation" do
    setup [:create_participation]

    test "renders form for editing chosen participation", %{
      conn: conn,
      participation: participation
    } do
      conn = get(conn, ~p"/participations/#{participation}/edit")
      assert html_response(conn, 200) =~ "Edit Participation"
    end
  end

  describe "update participation" do
    setup [:create_participation]

    test "redirects when data is valid", %{conn: conn, participation: participation} do
      conn = put(conn, ~p"/participations/#{participation}", participation: @update_attrs)
      assert redirected_to(conn) == ~p"/participations/#{participation}"

      conn = get(conn, ~p"/participations/#{participation}")
      assert html_response(conn, 200) =~ "some updated licence_number"
    end

    test "renders errors when data is invalid", %{conn: conn, participation: participation} do
      conn = put(conn, ~p"/participations/#{participation}", participation: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Participation"
    end
  end

  describe "delete participation" do
    setup [:create_participation]

    test "deletes chosen participation", %{conn: conn, participation: participation} do
      conn = delete(conn, ~p"/participations/#{participation}")
      assert redirected_to(conn) == ~p"/participations"

      assert_error_sent 404, fn ->
        get(conn, ~p"/participations/#{participation}")
      end
    end
  end

  defp create_participation(_) do
    participation = participation_fixture()
    %{participation: participation}
  end
end
