fs      = require 'fs'
path    = require 'path'
process = require 'process'

bumpMinor =
bumpMajor = false # to be command line switches later
manifestPath = "module.json"

{version} = manifest =
  JSON.parse (
    fs.readFileSync manifestPath
      .toString()
  )

[major, minor, patch] = version.split '.'

switch
  when bumpMajor then ( major++; minor = patch = 0 )
  when bumpMinor then ( minor++;         patch = 0 )
  else                  patch++

manifest.version  = version = [major, minor, patch].join '.'
manifest.download = "https://github.com/thatsnice/FVTT-OnDeck/archive/v#{version}.zip"

fs.writeFileSync manifestPath, JSON.stringify manifest, null, 2

