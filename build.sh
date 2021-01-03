PROJECT_ROOT=$(realpath $(dirname $0))
SCRIPTS=$PROJECT_ROOT\scripts
SRC=$PROJECT_ROOT\src

mkdir   -p $SCRIPTS
$coffee -o $SCRIPTS $SRC
