###

fs = require 'fs'

FS_ROOT = __dirname

isDir = (target) ->
  new Promise (resolve, reject) ->
    dir = fs.opendir target, (err, files) ->
      if err
        return reject err

      dir.close()
        .then -> resolve true
        .catch reject


mkdirp = (target) ->
  paths = [target]

  while target.length > 1 and not isDir target
    paths.unshift target = path.dirname target

  for target in paths
    await fs.mkdir

task 'build', 'build', (options) ->
  mkdirp scriptDir
  compile

###
