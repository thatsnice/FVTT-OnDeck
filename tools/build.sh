PROJECT_ROOT=$(realpath $(dirname $0)/..)
SCRIPTS=$PROJECT_ROOT/scripts
SRC=$PROJECT_ROOT/src
NODE=$PROJECT_ROOT/node_modules
COFFEE=$NODE/coffeescript/bin/coffee
JQ=$NODE/node-jq/bin/jq

if ! [ -x $COFFEE ]; then
  npm install
fi

mkdir   -p $SCRIPTS
$COFFEE -o $SCRIPTS $SRC
