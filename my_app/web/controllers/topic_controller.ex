defmodule MyApp.TopicController do
  use MyApp.Web, :controller

  alias MyApp.Topic

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})

    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"topic" => topic}) do
    IO.inspect(topic)


    changeset = Topic.changeset(%Topic{}, topic)
    Repo.insert(changeset)


    render conn, "new.html", changeset: Topic.changeset(%Topic{}, %{})
  end
end
