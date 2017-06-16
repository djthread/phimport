defmodule Phimport do
  alias Phimport.{CLI, Action}

  @sddir "/Volumes/Untitled/DCIM"

  def main(args) do
    args
    |> CLI.parse_args
    |> CLI.merge_defaults
    |> run_actions
  end

  defp run_actions(state) do
    state
    |> Action.Import.run(@sddir)
  end

end
