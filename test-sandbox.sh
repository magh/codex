#!/bin/bash

echo "Testing Codex without sandbox..."
echo ""

# Test 1: Try to access network (would fail with sandbox)
echo "Test 1: Network access"
curl -s -o /dev/null -w "Network access: %{http_code}\n" https://www.google.com

# Test 2: Try to write outside current directory (would fail with sandbox)
echo ""
echo "Test 2: File write outside current directory"
echo "test" > /tmp/codex-sandbox-test.txt 2>&1 && echo "File write: SUCCESS" || echo "File write: FAILED"
rm -f /tmp/codex-sandbox-test.txt 2>/dev/null

# Test 3: Check environment variable
echo ""
echo "Test 3: Sandbox environment variable"
echo "CODEX_SANDBOX_NETWORK_DISABLED: ${CODEX_SANDBOX_NETWORK_DISABLED:-not set}"

echo ""
echo "If all tests show SUCCESS/200 and the env var is not set, sandbox is disabled."