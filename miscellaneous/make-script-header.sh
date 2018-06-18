#!/bin/bash
# Create a DEFAULT HEADER for new scripts
# Based on: https://kvz.io/blog/2013/11/21/bash-best-practices/
# Author: Mateus Sousa (n00b) - June,2018
#
if [ $# -lt 1 ]; then
    echo "Usage: $0 script.sh"
    exit 1
fi

RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # no color

_script="${1:-}"

echo '#!/bin/sh
# PUT your script information here
#
#
#
#
#
#                   DEFAULT HEADER
set -o errexit # to exit when an error appears
set -o pipefail # in scripts to catch mysqldump fails in e.g. mysqldump |gzip.
# The exit status of the last command that threw a non-zero exit code is returned.
set -o nounset # to exit when your script tries to use undeclared variables.

__dir="${dinarme ${BASH_SOURCE[0]} && pwd}"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename ${__file} .sh)"
__root="$(cd "$(dirname "${__dir}")" && pwd)"

# Some colors
RED="\033[0;31m"
BLUE="\033[0;34m"
NC="\033[0m\" # no color

arg1="${1:-}"
#                 END DEFAULT
' > "${_script}"

[ $? -eq 0 ] && printf "${BLUE}[+]HEADER created in '${_script}'${NC}\n" || printf "${RED}[-]Error!${NC}"
