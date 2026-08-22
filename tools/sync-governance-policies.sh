#!/usr/bin/env bash
# Re-mirror shared policies from the canonical design-time source into the
# governance bundle. Run this after editing any shared policy, or whenever
# tools/check-drift.sh reports drift.
#
#   Canonical (source of truth):  Weather-Shield-Gateway/{02-Mediation,...}
#   Mirrored:                     Shared-Flows-Governance/Weather-Shield-Gateway/policies/
#
# Usage: ./tools/sync-governance-policies.sh

set -euo pipefail

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

for rel in "${SHARED[@]}"; do
  cp "$SRC/$rel" "$MIR/$(basename "$rel")"
  echo "🔁 synced $(basename "$rel")"
done

./tools/check-drift.sh
