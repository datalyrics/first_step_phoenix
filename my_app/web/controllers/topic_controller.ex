defmodule MyApp.TopicController do
  use MyApp.Web, :controller

  def new(conn, _params) do
    render conn, "new.html"
  end

end
