defmodule Phimport.CLI do
  alias Phimport.State

  def parse_args(args) do
    {options, _, _} = OptionParser.parse(args,
      switches: [
        dry:       :boolean,
        targetdir: :string,
        videosdir: :string
      ],
      aliases: [
        d: :dry,
        t: :targetdir,
        v: :videosdir
      ]
    )

    %State{options: options}
  end

  def merge_defaults(state) do
    [
      dry:       false,
      targetdir: nil,
      videosdir: nil
    ]
    |> Keyword.merge(state.options)
    |> fn(options) ->
      Map.put(state, :options, options |> Enum.into(%{}))
    end.()
  end

end
