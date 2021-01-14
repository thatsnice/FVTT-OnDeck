fs      = require 'fs'

manifestPath = "module.json"

{version} = manifest =
  JSON.parse (
    fs.readFileSync manifestPath
      .toString()
  )

[major, minor, patch] = version.split '.'

manifest.download = "https://github.com/thatsnice/FVTT-OnDeck/archive/v#{version}.zip"

fs.writeFileSync manifestPath, JSON.stringify manifest, null, 2
