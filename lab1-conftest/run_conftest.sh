#!/bin/bash

# Configuration
set -e
OUTPUT_DIR="sbom"
POLICY_DIR="policies"
MANIFESTS=("manifests/deployment-insecure.yaml" "manifests/deployment-secure.yaml")
REPORTS=("report_conftest_insecure.json" "report_conftest_secure.json")

# Create output directory
mkdir -p "$OUTPUT_DIR"

echo "🔍 Validating policy syntax..."
conftest verify --policy "$POLICY_DIR" || {
    echo "⚠️  Policy verification found issues, but continuing with tests..."
}

# Test manifests and generate reports
for i in "${!MANIFESTS[@]}"; do
    manifest="${MANIFESTS[$i]}"
    report="${REPORTS[$i]}"
    
    echo "🔍 Ejecutando Conftest sobre $manifest..."
    
    # Run conftest but capture the exit code to handle failures
    set +e
    conftest test "$manifest" --policy "$POLICY_DIR" --output json > "$OUTPUT_DIR/$report"
    TEST_EXIT_CODE=$?
    set -e
    
    # Check if report was created and has content
    if [[ -s "$OUTPUT_DIR/$report" ]]; then
        echo "✅ Report generated: $OUTPUT_DIR/$report"
        
        # Display summary from the JSON report
        echo "📊 Summary for $manifest:"
        jq -r '.[] | "  Results: \(.results | length), Failures: \((.failures // []) | length)"' "$OUTPUT_DIR/$report" 2>/dev/null || 
        echo "  (Install 'jq' for better JSON parsing)"
    else
        echo "❌ Failed to generate report for $manifest"
    fi
    
    # Show human-readable output for context
    echo "📝 Test output:"
    conftest test "$manifest" --policy "$POLICY_DIR" --output stdout || true
    echo ""
done

echo "🎉 Proceso completado. Reportes en $OUTPUT_DIR/"