#!/bin/sh

# Build ctags for the repository

# Die on error
set -o errexit

# Git directory
DIR="$(git rev-parse --git-dir)"

# Temporary tag location ($$ is the script PID)
TMPTAG="${DIR}/$$.tags"

# Final tag location
TAGLOC="${DIR}/tags"

# Get working tree directory
WRKTREE="${DIR}/.."

# List of C/C++ header locations
HEADLIST="${DIR}/$$.list"

# Remove temporary tags on exit (if still existing)
trap 'rm -f "${TMPTAG}" ${HEADLIST}' EXIT

# Find all included headers in C/C++ files
find "${WRKTREE}" -regextype posix-extended \
	-iregex '.*\.(c|cc|cpp|c\+\+|h|hpp|h\+\+)$' -print0 |
	xargs -0 -I FILE cpp -w -H FILE 2>&1 >/dev/null |
	grep '^\. ' |
	sed 's/^\. //' |
	sort |
	uniq > "${HEADLIST}"

# Build ctags database
ctags --tag-relative -L "${HEADLIST}" -f "${TMPTAG}" -R "${WRKTREE}"

# Move the temporary ctags database to the desired location
mv "${TMPTAG}" "${TAGLOC}"
