defmodule TodoApiWeb.SessionView do
  use TodoApiWeb, :view
  alias TodoApiWeb.SessionView

  def render("show.json", %{session: session}) do
    %{data: render_one(session, SessionView, "session.json")}
  end

  def render("session.json", %{session: session}) do
    %{token: session.token}
  end
end
