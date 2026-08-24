#!/usr/bin/env bash
set -euo pipefail

script_dir="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
repo_root="$(CDPATH= cd -- "${script_dir}/.." && pwd -P)"

src="${repo_root}/AGENTS.md"
dst="${CODEX_AGENTS_PATH:-${HOME}/.codex/AGENTS.md}"
dst_dir="$(dirname -- "${dst}")"
tmp=""

usage()
{
	printf 'Usage: %s [--check]\n' "$(basename -- "$0")"
	printf '\n'
	printf 'Copy this repository AGENTS.md to %s.\n' "${dst}"
	printf 'Set CODEX_AGENTS_PATH to override the destination.\n'
}

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
	usage
	exit 0
fi

if [ "${1:-}" = "--check" ]; then
	if cmp -s -- "${src}" "${dst}"; then
		printf 'Already up to date: %s\n' "${dst}"
		exit 0
	fi

	printf 'Needs update: %s\n' "${dst}"
	exit 1
fi

if [ "$#" -ne 0 ]; then
	usage >&2
	exit 2
fi

if [ ! -f "${src}" ]; then
	printf 'Missing source file: %s\n' "${src}" >&2
	exit 1
fi

mkdir -p -- "${dst_dir}"
tmp="$(mktemp -- "${dst_dir}/.AGENTS.md.XXXXXX")"
trap 'if [ -n "${tmp}" ]; then rm -f -- "${tmp}"; fi' EXIT

install -m 0644 -- "${src}" "${tmp}"
mv -f -- "${tmp}" "${dst}"
tmp=""

printf 'Updated %s from %s\n' "${dst}" "${src}"
