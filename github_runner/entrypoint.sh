#!/usr/bin/env bash
set -euo pipefail

: "${ORG:?Set ORG}"
: "${ACCESS_TOKEN:?Set ACCESS_TOKEN}"

REG_TOKEN=$(curl -fsSL -X POST -H "Authorization: token ${ACCESS_TOKEN}" -H "Accept: application/vnd.github+json" https://api.github.com/orgs/${ORG}/actions/runners/registration-token | jq .token --raw-output)
name="${RUNNER_NAME:-$(hostname)}"
labels="${RUNNER_LABELS:-}"
workdir="${RUNNER_WORKDIR:-_work}"
ephemeral="${RUNNER_EPHEMERAL:-1}"

cd ${RUNNER_HOME}

if [[ ! -f .runner ]]; then
  echo "Configuring runner..."
  args=(--url "https://github.com/${ORG}" --token "$REG_TOKEN" --name "$name" --work "$workdir" --unattended --replace)
  [[ -n "$labels" ]] && args+=(--labels "$labels")
  [[ "$ephemeral" == "1" ]] && args+=(--ephemeral)
  ./config.sh "${args[@]}"
fi

cleanup() {
  echo "Removing runner..."
  REM_TOKEN=$(curl -fsSL -X POST -H "Authorization: token ${ACCESS_TOKEN}" -H "Accept: application/vnd.github+json" https://api.github.com/orgs/${ORG}/actions/runners/remove-token | jq .token --raw-output)
  ./config.sh remove --token ${REM_TOKEN}
}
trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!
