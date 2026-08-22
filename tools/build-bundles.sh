#!/usr/bin/env bash
# Assemble deployable apiproxy bundles from design-time project folders.
#
# Design-time layout (per project):
#   <Project>/<x>-proxy.xml              -> API proxy definition
#   <Project>/01-API-Design/*.yaml       -> OpenAPI spec (docs only, not deployed)
#   <Project>/02-Mediation/*.xml|js      -> policies / jsc resources
#   <Project>/03-Security/*.xml          -> policies
#   <Project>/04-Monetization/*.xml      -> policies
#   <Project>/05-Proxy-Wiring/*.xml      -> ProxyEndpoint / TargetEndpoint
#
# Output layout (what Apigee actually accepts):
#   target/<Project>/apiproxy/<proxy>.xml
#   target/<Project>/apiproxy/proxies/default.xml
#   target/<Project>/apiproxy/targets/default.xml   (optional)
#   target/<Project>/apiproxy/policies/*.xml
#   target/<Project>/apiproxy/resources/jsc/*.js
#
# Usage: ./tools/build-bundles.sh [output-dir]   (default: target)

set -euo pipefail

OUT="${1:-target}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
shopt -s nullglob

PROJECTS=(
  "Weather-Shield-Gateway"
  "Secure-Bank-Access"
  "Retail-Mesh-Orchestrator"
  "Apigee-DevOps-Pipeline"
)

copy_policies() {
  local src_dir="$1" dest_dir="$2"
  [[ -d "$src_dir" ]] || return 0
  find "$src_dir" -name '*.xml' -type f -print0 | while IFS= read -r -d '' f; do
    cp "$f" "$dest_dir/"
  done
}

for proj in "${PROJECTS[@]}"; do
  src="$ROOT/$proj"
  dest="$OUT/$proj/apiproxy"

  proxy_def=("$src"/*-proxy.xml)
  [[ ${#proxy_def[@]} -gt 0 ]] || { echo "❌ $proj: no *-proxy.xml found"; exit 1; }

  rm -rf "$OUT/$proj"
  mkdir -p "$dest/proxies" "$dest/targets" "$dest/policies" "$dest/resources/jsc"

  cp "${proxy_def[@]}" "$dest/"

  if [[ -f "$src/05-Proxy-Wiring/proxy-endpoint-default.xml" ]]; then
    cp "$src/05-Proxy-Wiring/proxy-endpoint-default.xml" "$dest/proxies/"
  fi
  if [[ -f "$src/05-Proxy-Wiring/target-endpoint-default.xml" ]]; then
    cp "$src/05-Proxy-Wiring/target-endpoint-default.xml" "$dest/targets/"
  fi

  copy_policies "$src/02-Mediation" "$dest/policies"
  copy_policies "$src/03-Security" "$dest/policies"
  copy_policies "$src/04-Monetization" "$dest/policies"

  if [[ -d "$src/02-Mediation" ]]; then
    find "$src/02-Mediation" -name '*.js' -type f -exec cp {} "$dest/resources/jsc/" \;
  fi

  echo "✅ $proj -> $dest ($(find "$dest" -type f | wc -l | tr -d ' ') files)"
done

# ---------------------------------------------------------------------------
# Shared-Flows-Governance contains two pre-assembled bundles (no design-time
# numbered layout), staged as-is:
#   Weather-Shield-Gateway/   -> API proxy bundle that consumes the shared flow
#   Security-Governance-v1/   -> SharedFlowBundle (deployed as shared flow)
# ---------------------------------------------------------------------------

# Staged so that each lintable path ends in the folder name apigeelint
# requires:  .../apiproxy  or  .../sharedflowbundle

GOV="$ROOT/Shared-Flows-Governance"

rm -rf "$OUT/Shared-Flows-Demo"
mkdir -p "$OUT/Shared-Flows-Demo/apiproxy"
cp -R "$GOV/Weather-Shield-Gateway/." "$OUT/Shared-Flows-Demo/apiproxy/"
echo "✅ Shared-Flows-Demo -> $OUT/Shared-Flows-Demo/apiproxy ($(find "$OUT/Shared-Flows-Demo" -type f | wc -l | tr -d ' ') files, staged as-is)"

rm -rf "$OUT/Shared-Flow-Governance"
mkdir -p "$OUT/Shared-Flow-Governance/sharedflowbundle"
cp -R "$GOV/Security-Governance-v1/." "$OUT/Shared-Flow-Governance/sharedflowbundle/"
echo "✅ Shared-Flow-Governance -> $OUT/Shared-Flow-Governance/sharedflowbundle ($(find "$OUT/Shared-Flow-Governance" -type f | wc -l | tr -d ' ') files, staged as-is)"
