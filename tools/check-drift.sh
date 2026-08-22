#!/usr/bin/env bash
# Drift guard: the governed proxy's shared policies exist in two places.
#
#   Canonical (edit here):        Weather-Shield-Gateway/{02-Mediation,03-Security,04-Monetization}
#   Mirrored copy (auto-synced):  Shared-Flows-Governance/Weather-Shield-Gateway/policies/
#
# The mirrored copies must stay byte-identical to canonical. CI fails here
# if anyone edits one side without the other. Re-sync manually with:
#   ./tools/sync-governance-policies.sh
#
# Usage: ./tools/check-drift.sh    (exit 0 = clean, exit 1 = drift found)

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$ROOT/Weather-Shield-Gateway"
MIR="$ROOT/Shared-Flows-Governance/Weather-Shield-Gateway/policies"

SHARED=(
  "02-Mediation/Fault-Quota-Failure.xml"
  "03-Security/AM-Set-Secret-Key.xml"
  "03-Security/Verify-JWT-Protection.xml"
  "04-Monetization/Quota-Silver-Tier.xml"
  "02-Mediation/Response-Cache-Standard.xml"
  "02-Mediation/Service-Callout-Logging.xml"
  "02-Mediation/XML-to-JSON-Conversion.xml"
)

drift=0
for rel in "${SHARED[@]}"; do
  file="$(basename "$rel")"
  canon="$SRC/$rel"
  mirror="$MIR/$file"

  if [[ ! -f "$canon" ]]; then
    echo "❌ MISSING canonical: $rel"
    drift=1
    continue
  fi
  if [[ ! -f "$mirror" ]]; then
    echo "❌ MISSING mirror: $file (run ./tools/sync-governance-policies.sh)"
    drift=1
    continue
  fi
  if ! cmp -s "$canon" "$mirror"; then
    echo "⚠️  DRIFT: $file differs from canonical $rel"
    drift=1
  fi
done

if [[ $drift -eq 0 ]]; then
  echo "✅ No policy drift — mirrors match canonical sources."
fi
exit $drift
