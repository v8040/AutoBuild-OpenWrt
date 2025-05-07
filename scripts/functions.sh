#!/bin/bash
export TERM=xterm-256color
NC=$(tput sgr0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
_log() {
  local COLOR="${1}"
  local MESSAGE="${2}"
  local EXIT_FLAG="${3:-0}"
  local EXIT_CODE="${4:-1}"
  local OUTPUT_STREAM=$(( EXIT_FLAG ? 2 : 1 ))
  printf "${COLOR}%b${NC}\n" "${MESSAGE}" >&"${OUTPUT_STREAM}"
    if (( EXIT_FLAG )); then
    exit "${EXIT_CODE}"
  fi
}
info() { _log "${YELLOW}" "${*}" 0; }
warning() { _log "${RED}" "${*}" 0; }
success() { _log "${GREEN}" "[DONE]" 0; }
error() { _log "${RED}" "${*}" 1; }
rm_pkg() {
  local TARGET="${1}"
  local -a DIRS=()
  while IFS= read -r -d ''; do
    DIRS+=("${REPLY}")
  done < <(find ./ -maxdepth 4 -iname "${TARGET}" -type d -print0)
  if (( ${#DIRS[@]} == 0 )); then
    warning "Not found [${TARGET}]"
  fi
  if ! printf "%s\0" "${DIRS[@]}" | xargs -0 rm -rf --; then
    warning "Failed to remove directories [${TARGET}]"
  fi
}
sparse_clone() {
  local BRANCH="${1}" REPOURL="${2}" REPODIR="${3}"
  local CACHE_DIR="$(mktemp -d)"
  trap "rm -rf -- \"${CACHE_DIR}\"" EXIT
  if ! git clone -q --branch="${BRANCH}" --depth=1 --filter=blob:none --sparse "${REPOURL}" "${CACHE_DIR}" &>/dev/null; then
    warning "Failed to clone repository ${REPOURL} (branch: ${BRANCH})"
  fi
  if ! git -C "${CACHE_DIR}" sparse-checkout set "${REPODIR}" &>/dev/null; then
    warning "Failed to sparse-checkout directory ${REPODIR} from ${REPOURL}"
  fi
  mkdir -p package
  if [[ -d "package/${REPODIR}" ]]; then
    rm -rf "package/${REPODIR}"
  fi
  mv -f "${CACHE_DIR}/${REPODIR}" package
}
sub_file() {
  local OLD="${1}" NEW="${2}" FILE="${3}"
  local NEW_ESCAPED=$(printf '%s\n' "${NEW}" | sed 's/[&|]/\\&/g')
  if [[ -f "${FILE}" ]]; then
    sed -i "s|\Q${OLD}\E|${NEW_ESCAPED}|g" "${FILE}" || warning "Replace failed in [${FILE}]"
  fi
}
sub_name() {
  local SEARCH_TEXT="${1}" NEW_TEXT="${2}"
  local -a FILES=()
  mapfile -t FILES < <(grep -rl -- "${SEARCH_TEXT}" ./ 2>/dev/null)
  if ! [[ ${#FILES[@]} -eq 0 ]]; then
    for FILE in "${FILES[@]}"; do
      sub_file "${SEARCH_TEXT}" "${NEW_TEXT}" "${FILE}"
    done
  fi
}
sub_makefiles() {
  local OLD="${1}" NEW="${2}"
  local FILE
  while IFS= read -r -d '' FILE; do
    sub_file "${OLD}" "${NEW}" "${FILE}"
  done < <(find package/*/ -maxdepth 2 -path "*/Makefile" -print0)
}