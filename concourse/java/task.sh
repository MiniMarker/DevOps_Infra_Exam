#!/bin/sh
# we don't to anything with the artifact yet - we just want to build it.
set -ueo pipefail

export GREEN='\033[1;32m'
export NC='\033[0m'
export CHECK="√"
export M2_LOCAL_REPO=".m2"

# START Caching
export ROOT_FOLDER=$( pwd )
export REPO=repo

M2_HOME="${HOME}/.m2"
M2_CACHE="${ROOT_FOLDER}/maven"

echo "Generating symbolic links for caches"

[[ -d "${M2_CACHE}" && ! -d "${M2_HOME}" ]] && ln -s "${M2_CACHE}" "${M2_HOME}"

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

#. ${SCRIPTS_DIR}/generate-settings.sh

[[ -f "${SCRIPTS_DIR}/functions.sh" ]] && source "${SCRIPTS_DIR}/functions.sh" || \
echo "No functions.sh found"

# END Caching


mvn -f source/pom.xml install 
echo -e "${GREEN}${CHECK} Maven install${NC}"
