#!/usr/bin/env bash
# Auto-runs when the project opens in Google Cloud Shell.
# Validates the Weather-Shield-Gateway proxy bundle structure.
set -euo pipefail

echo "=============================================="
echo "  Apigee-Lab · Weather-Shield-Gateway"
echo "=============================================="
echo ""

PROXY_DIR="Weather-Shield-Gateway"

# 1. Check the bundle structure
echo "1/4 Checking bundle structure..."
for dir in "01-API-Design" "02-Mediation" "03-Security" "04-Monetization" "05-Proxy-Wiring"; do
  if [ -d "$PROXY_DIR/$dir" ]; then
    echo "   [OK] $dir/"
  else
    echo "   [MISSING] $dir/"
  fi
done

# 2. Validate the proxy XML is well-formed
echo "2/4 Validating proxy XML..."
if command -v xmllint >/dev/null 2>&1; then
  if xmllint --noout "$PROXY_DIR/weather-proxy.xml" >/dev/null 2>&1; then
    echo "   [OK] weather-proxy.xml is well-formed XML"
  else
    echo "   [ERROR] weather-proxy.xml is malformed"
  fi
else
  echo "   [SKIP] xmllint not installed"
fi

# 3. Show the OpenAPI spec summary
echo "3/4 OpenAPI spec:"
grep -E "^(title|version|host|basePath)" "$PROXY_DIR/01-API-Design/weather-api-v1.yaml" 2>/dev/null \
  | sed 's/^/   /' || echo "   (spec not found at expected path)"

# 4. Ready message
echo ""
echo "4/4 Ready!"
echo ""
echo "   Bundle is ready to explore:"
echo "   cd $PROXY_DIR"
echo ""
echo "   Deployment guide: https://github.com/SunnyJayaRaju/Apigee-Lab/tree/main/Weather-Shield-Gateway"
echo "=============================================="