fs      = require 'fs'
path    = require 'path'
process = require 'process'

bumpMinor =
bumpMajor = false # to be command line switches later
manifestPath = "module.json"
packagePath  = "package.json"

{version} = manifest =
  JSON.parse (
    fs.readFileSync manifestPath
      .toString()
  )

packageJSON = JSON.parse (
    fs.readFileSync packagePath
      .toString()
  )

[major, minor, patch] = version.split '.'

switch
  when bumpMajor then ( major++; minor = patch = 0 )
  when bumpMinor then ( minor++;         patch = 0 )
  else                  patch++

manifest.version  = version = [major, minor, patch].join '.'
manifest.download = "https://github.com/thatsnice/FVTT-OnDeck/archive/v#{version}.zip"


packageJSON.version = version


fs.writeFileSync manifestPath, JSON.stringify manifest,    null, 2
fs.writeFileSync packagePath,  JSON.stringify packageJSON, null, 2
