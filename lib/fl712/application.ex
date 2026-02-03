defmodule Fl712.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [{Fl712, System.fetch_env!("BOT_ACCESS_TOKEN")}]
    opts = [strategy: :one_for_one, name: Fl712.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
