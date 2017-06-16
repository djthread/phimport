defmodule Phimport.Util do

  def fail(error) do
    IO.puts("Error: #{error}\n")

    IO.puts """
Usage
  --targetdir, -t  Dir to copy to
  --videosdir, -v  Dir to copy videos to
  --dry, -y        Only show commands to run; do not execute
    """

    System.halt(0)
  end

  def assert_has_videosdir(state) do
    case is_binary(state.options.videosdir) do
      true  -> state
      false -> fail "--videosdir required"
    end
  end

  def assert_has_targetdir(state) do
    case is_binary(state.options.targetdir) do
      true  -> state
      false -> fail "--targetdir required"
    end
  end

  def glob(sddir, ext) do
    sddir
    |> Path.join("/**/*." <> ext)
    |> Path.wildcard
  end

  # def process(state = %State{options: options, selection: [file | selection]}, func) do
  #   base =
  #     file
  #     |> Path.basename(".jpg")
  #     |> Path.basename(".tif")
  #
  #   raw =
  #     options.rawdir
  #     |> Path.join("#{base}.RAF")
  #
  #   case File.exists?(raw) do
  #     false -> IO.puts("Missing raw: #{raw}")
  #     true  -> func.(raw, options.dry)
  #   end
  #
  #   process(%{state | selection: selection}, func)
  # end
  # def process(state = %State{selection: []}, _func) do
  #   state
  # end
end
