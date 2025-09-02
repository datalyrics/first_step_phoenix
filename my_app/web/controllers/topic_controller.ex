defmodule MyApp.TopicController do
  use MyApp.Web, :controller

  alias MyApp.Topic

  def new(conn, params) do
    changeset = Topic.changeset(%Topic{}, %{})

    render conn, "new.html", changeset: changeset
  end

end
