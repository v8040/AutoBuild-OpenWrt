#!/usr/bin/env bash
export TERM='xterm-256color'
if command -v tput &>/dev/null; then
  declare -grA COLORS=(
    ['NC']="$(tput sgr0)"
    ['ERROR']="$(tput setaf 1)"
    ['SUCCESS']="$(tput setaf 2)"
    ['INFO']="$(tput setaf 3)"
    ['BLUE']="$(tput setaf 4)"
    ['WARNING']="$(tput setaf 5)"
  )
else
  declare -grA COLORS=(
    ['NC']='\033[0m'
    ['ERROR']='\033[0;31m'
    ['SUCCESS']='\033[0;32m'
    ['INFO']='\033[0;33m'
    ['BLUE']='\033[0;34m'
    ['WARNING']='\033[0;35m'
  )
fi
_log() {
  local PREFIX="$1"
  local MESSAGE="$2"
  local STATUS_CODE="${3:-0}"
  local SHOW_TIME="${4:-1}"
  local COLOR="${COLORS[${PREFIX}]}"
  local OUTPUT_STREAM=$(( STATUS_CODE != 0 ? 2 : 1 ))
  local TIMESTAMP
  if [[ "${SHOW_TIME}" == "1" ]]; then
    printf -v TIMESTAMP '%(%Y-%m-%d %H:%M:%S)T' -1
    printf '%b%s%b [ %b%s%b ] %s\n' \
      "${COLORS[BLUE]}" "${TIMESTAMP}" "${COLORS[NC]}" \
      "${COLOR}" "${PREFIX}" "${COLORS[NC]}" \
      "${MESSAGE}" >&"${OUTPUT_STREAM}"
  else
    printf '[ %b%s%b ] %s\n' \
      "${COLOR}" "${PREFIX}" "${COLORS[NC]}" \
      "${MESSAGE}" >&"${OUTPUT_STREAM}"
  fi
  [[ "${PREFIX}" == 'ERROR' ]] && exit "${STATUS_CODE}"
  return "${STATUS_CODE}"
}
info() { _log 'INFO' "$*" 0 0; }
success() { _log 'SUCCESS' "$*" 0 0; }
warning() { _log 'WARNING' "$*" 1 0; }
error() { _log 'ERROR' "$*" 1 0; }
sparse_clone() {
  local BRANCH="$1" REPOURL="$2" REPODIR="${3%/}"
  [[ -z "${BRANCH}" || -z "${REPOURL}" || -z "${REPODIR}" ]] && return 1
  local CACHE_DIR
  CACHE_DIR="$(mktemp -d)"
  trap 'rm -rf -- "${CACHE_DIR}"' RETURN
  if ! git clone -q --branch="${BRANCH}" --depth=1 --no-tags --filter=blob:none --sparse "${REPOURL}" "${CACHE_DIR}" &>/dev/null; then
    warning "Failed to clone repository ${REPOURL} (branch: ${BRANCH})"
  fi
  if ! git -C "${CACHE_DIR}" sparse-checkout set "${REPODIR}" &>/dev/null; then
    warning "Failed to sparse-checkout directory ${REPODIR} from ${REPOURL}"
  fi
  mkdir -p package
  rsync -a --delete "${CACHE_DIR}/${REPODIR}" package
  local TARGET_DIR PKG_NAME
  TARGET_DIR="package/$(basename "${REPODIR}")"
  PKG_NAME="$(basename "${TARGET_DIR}")"
  if [[ -d "${TARGET_DIR}" ]]; then
    find "${TARGET_DIR}" -maxdepth 3 -name Makefile -exec sed -i \
      -e 's|\.\./\.\./luci\.mk|$(TOPDIR)/feeds/luci/luci.mk|g' \
      -e 's|\.\./\.\./lang/golang/golang-package\.mk|$(TOPDIR)/feeds/packages/lang/golang/golang-package.mk|g' \
      -e 's|\.\./\.\./package\.mk|$(INCLUDE_DIR)/package.mk|g' \
      -e 's|\.\./\.\./kernel\.mk|$(INCLUDE_DIR)/kernel.mk|g' \
      -e 's|\.\./\.\./nls\.mk|$(INCLUDE_DIR)/nls.mk|g' \
      -e 's|PKG_SOURCE_URL:=@GHREPO|PKG_SOURCE_URL:=https://github.com|g' \
      -e 's|PKG_SOURCE_URL:=@GHCODELOAD|PKG_SOURCE_URL:=https://codeload.github.com|g' \
      {} +
    success "Sparse cloned [${PKG_NAME}]"
  fi
}
rm_pkg() {
  local TARGET="$1"
  [ -z "${TARGET}" ] && return 1
  local -a DIRS=()
  mapfile -d '' DIRS < <(find package feeds -maxdepth 5 -regextype posix-extended \
    -regex "package/(boot|devel|firmware|kernel|libs)" -prune -o \
    -type d -iname "${TARGET}" \
    -exec test -e "{}/Makefile" \; \
    -print0 -prune 2>/dev/null)
  if ! (( ${#DIRS[@]} )); then
    warning "Not found [${TARGET}]"
  elif ! { printf '%s\0' "${DIRS[@]}" | xargs -0r rm -rf -- && 
           for DIR in "${DIRS[@]}"; do info "Removed [${DIR}]"; done; }; then
    warning "Failed to remove [${TARGET}]"
  fi
}
sub_name() {
  local SEARCH_TEXT="$1" NEW_TEXT="$2"
  [[ -z "${SEARCH_TEXT}" ]] && return 1
  local ESCAPED_SEARCH
  ESCAPED_SEARCH="$(printf '%s\n' "${SEARCH_TEXT}" | sed -e 's/[]\/$*.^|[]/\\&/g')"
  local ESCAPED_NEW
  ESCAPED_NEW="$(printf '%s\n' "${NEW_TEXT}" | sed -e 's/|/\\|/g')"
  local -a FILES=()
  mapfile -d '' FILES < <(grep -rIlFZ --include=\*.{po,js,lua} \
    -- "${SEARCH_TEXT}" package feeds 2>/dev/null)
  if ! (( ${#FILES[@]} )); then
    warning "Not found [${SEARCH_TEXT}]"
  elif ! { printf '%s\0' "${FILES[@]}" | xargs -0r sed -i "s|${ESCAPED_SEARCH}|${ESCAPED_NEW}|g" -- &&
           for FILE in "${FILES[@]}"; do info "Modified [${FILE}]"; done; }; then
    warning "Failed to replace [${SEARCH_TEXT} -> ${NEW_TEXT}]"
  fi
}