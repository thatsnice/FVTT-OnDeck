PROJECT_ROOT=$(realpath $(dirname $0))
SCRIPTS=$PROJECT_ROOT/scripts
SRC=$PROJECT_ROOT/src
COFFEE=$PROJECT_ROOT/node_modules/coffeescript/bin/coffee

mkdir   -p $SCRIPTS
$COFFEE -o $SCRIPTS $SRC
$COFFEE $PROJECT_ROOT/tools/version-bump.coffee
echo "Version bumped to $(jq .version module.json)"
