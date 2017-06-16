defmodule Phimport.Action.Import do
  import Phimport.Util
  require Logger

  def run(state, sddir) do
    state |> assert_has_targetdir

    unless File.dir?(sddir) do
      fail "#{sddir} doesn't exist."
    end

    opts = state.options

    raws = glob(sddir, "RAF")
    jpgs = glob(sddir, "JPG")
    movs = glob(sddir, "MOV")

    for raw <- raws do
      cp(raw, opts.targetdir, opts.dry)
    end

    for jpg <- jpgs do
      raw_exists =
        ~r/\.JPG$/
        |> Regex.replace(jpg, ".RAF")
        |> File.exists?

      if not raw_exists,
        do: cp(jpg, opts.targetdir, opts.dry)
    end

    for mov <- movs do
      cp(mov, opts.videosdir, opts.dry)
    end
  end

  defp cp(source, dest, dry) do
    filename = Path.basename(source)
    target = find_target Path.join(dest, filename)

    if File.exists?(target) do
      Logger.warn " !! Renaming file; target exists: #{target}"
    else
      Logger.info " -> cp #{source} -> #{target}"

      unless dry do
        File.copy!(source, target)
      end
    end
  end

  defp find_target(original) do
    [_, base, ext] = Regex.run(~r/^(.+)\.([^\.]{1,3})$/, original)

    do_find_target(base, ext, 0)
  end

  defp do_find_target(base, ext, counter) do
    new_target =
      if counter == 0 do
        "#{base}.#{ext}"
      else
        "#{base}-#{counter}.#{ext}"
      end

    if File.exists?(new_target) do
      do_find_target(base, ext, counter + 1)
    else
      new_target
    end
  end
end
