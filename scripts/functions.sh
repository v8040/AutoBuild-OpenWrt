#!/usr/bin/env bash
export TERM=xterm-256color
declare -grA COLORS=(
  ["NC"]=$(tput sgr0)
  ["ERROR"]=$(tput setaf 1)
  ["SUCCESS"]=$(tput setaf 2)
  ["INFO"]=$(tput setaf 3)
  ["BLUE"]=$(tput setaf 4)
  ["WARNING"]=$(tput setaf 5)
)
_log() {
  local PREFIX="${1}"
  local MESSAGE="${2}"
  local STATUS_CODE="${3:-0}"
  local COLOR="${COLORS[${PREFIX}]}"
  local OUTPUT_STREAM=$(( STATUS_CODE != 0 ? 2 : 1 ))
  printf "%b[%s]%b %s\n" \
    "${COLOR}" "${PREFIX}" "${COLORS[NC]}" \
    "${MESSAGE}" >&"${OUTPUT_STREAM}"
  [[ "${PREFIX}" == "ERROR" ]] && exit "${STATUS_CODE}"
  return "${STATUS_CODE}"
}
info() { _log "INFO" "${*}" 0; }
success() { _log "SUCCESS" "${*}" 0; }
warning() { _log "WARNING" "${*}" 1; }
error() { _log "ERROR" "${*}" 1; }
sparse_clone() {
  local BRANCH="${1}" REPOURL="${2}" REPODIR="${3}"
  local CACHE_DIR="$(mktemp -d)"
  trap "rm -rf -- \"${CACHE_DIR}\"" EXIT
  if ! git clone -q --branch="${BRANCH}" --depth=1 --filter=blob:none --sparse "${REPOURL}" "${CACHE_DIR}" &>/dev/null; then
    warning "Failed to clone repository ${REPOURL} (branch: ${BRANCH})"
  elif ! git -C "${CACHE_DIR}" sparse-checkout set "${REPODIR}" &>/dev/null; then
    warning "Failed to sparse-checkout directory ${REPODIR} from ${REPOURL}"
  else
    rsync -a --delete "${CACHE_DIR}/${REPODIR}" package
  fi
}
rm_pkg() {
  local TARGET="${1}"
  local -a DIRS=()
  mapfile -d $'\0' DIRS < <(find . -maxdepth 4 -iname "${TARGET}" -type d -print0 2>/dev/null)
  if ! (( ${#DIRS[@]} )); then
    warning "Not found [${TARGET}]"
  elif ! printf "%s\0" "${DIRS[@]}" | xargs -0r rm -rf --; then
    warning "Failed to remove [${TARGET}]"
  fi
}
sub_name() {
  local SEARCH_TEXT="${1}" NEW_TEXT="${2}"
  local -a FILES=()
  mapfile -d $'\0' FILES < <(grep -rlFZ --include='*.po*' --include='*.js*' --include='*.lua*' -- "${SEARCH_TEXT}" . 2>/dev/null)
  if ! (( ${#FILES[@]} )); then
    warning "Not found [${SEARCH_TEXT}]"
  elif ! printf "%s\0" "${FILES[@]}" | xargs -0r sed -i "s/${SEARCH_TEXT}/${NEW_TEXT}/g" --; then
    warning "Failed to replace [${SEARCH_TEXT} -> ${NEW_TEXT}]"
  fi
}