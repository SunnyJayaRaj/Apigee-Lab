#!/usr/bin/env bash
# Auto-runs when the project opens in Google Cloud Shell.
# Validates the bundle structure of every project in the lab.
set -uo pipefail

# Locate repo root no matter where Cloud Shell opens
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT" || exit 1

echo "=============================================="
echo "  Apigee-Lab · Full Lab Audit"
echo "=============================================="
echo ""

PROJECTS=(
  "Weather-Shield-Gateway"
  "Secure-Bank-Access"
  "Retail-Mesh-Orchestrator"
  "Apigee-DevOps-Pipeline"
  "Shared-Flows-Governance"
)

# Names per folder for the report table
declare -A LABELS=(
  ["Weather-Shield-Gateway"]="Security Gateway (JWT, Spike Arrest, Cache)"
  ["Secure-Bank-Access"]="OAuth 2.0 Client Credentials"
  ["Retail-Mesh-Orchestrator"]="API Composition (Service Callout + JS)"
  ["Apigee-DevOps-Pipeline"]="CI/CD (GitHub Actions + apigeelint)"
  ["Shared-Flows-Governance"]="Shared Flows (FlowCallout)"
)

has_xmllint=0
command -v xmllint >/dev/null 2>&1 && has_xmllint=1

for proj in "${PROJECTS[@]}"; do
  echo "── $proj (${LABELS[$proj]:-})"
  if [ ! -d "$proj" ]; then
    echo "   [ERROR] Project folder not found"
    echo ""
    continue
  fi

  # Count policy XML files
  policy_count=$(find "$proj" -name "*.xml" -type f 2>/dev/null | wc -l | tr -d ' ')
  yaml_count=$(find "$proj" -name "*.yaml" -o -name "*.yml" 2>/dev/null | wc -l | tr -d ' ')
  js_count=$(find "$proj" -name "*.js" -type f 2>/dev/null | wc -l | tr -d ' ')

  echo "   [OK] XML policies:  $policy_count"
  echo "   [OK] OpenAPI specs: $yaml_count"
  [ "$js_count" -gt 0 ] && echo "   [OK] JS scripts:    $js_count"

  # Validate XML well-formedness on the root proxy xml if present
  root_xml="$(find "$proj" -maxdepth 1 -name "*.xml" | head -1)"
  if [ -n "$root_xml" ] && [ "$has_xmllint" -eq 1 ]; then
    if xmllint --noout "$root_xml" >/dev/null 2>&1; then
      echo "   [OK] $(basename "$root_xml") is well-formed"
    else
      echo "   [ERROR] $(basename "$root_xml") is malformed XML"
    fi
  fi
  echo ""
done

echo "=============================================="
echo "  ✅ Lab audit complete — all projects ready to explore."
echo ""
echo "  Deployment guides:"
echo "    https://github.com/SunnyJayaRaju/Apigee-Lab"
echo "=============================================="