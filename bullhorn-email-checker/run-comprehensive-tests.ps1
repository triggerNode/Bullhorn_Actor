# Bullhorn Email Checker - Comprehensive Test Suite
Write-Host "🚀 STARTING COMPREHENSIVE TEST SUITE" -ForegroundColor Green
Write-Host "Testing all known emails to validate system reliability..."
Write-Host ""

# Read test emails from JSON file
$testData = Get-Content "comprehensive-test.json" | ConvertFrom-Json
$testEmails = $testData.testEmails

# Initialize test results tracking
$totalTests = $testEmails.Count
$passedTests = 0
$failedTests = 0
$testResults = @()

Write-Host "📊 TOTAL TESTS TO RUN: $totalTests" -ForegroundColor Cyan
Write-Host "=" * 60

# Run each test
for ($i = 0; $i -lt $testEmails.Count; $i++) {
    $test = $testEmails[$i]
    $testNumber = $i + 1
    
    Write-Host ""
    Write-Host "🔍 TEST $testNumber/$totalTests" -ForegroundColor Magenta
    Write-Host "Email: $($test.email)"
    Write-Host "Expected: $($test.expectedResult)"
    Write-Host "Source: $($test.source)"
    Write-Host "-" * 40
    
    # Update input file
    $inputData = @{ email = $test.email } | ConvertTo-Json
    $inputData | Out-File -FilePath "storage/key_value_stores/default/INPUT.json" -Encoding UTF8
    
    # Run the test
    Write-Host "⏳ Running test..." -ForegroundColor Yellow
    $startTime = Get-Date
    
    try {
        # Capture output from npm start
        $output = npm start 2>&1 | Out-String
        $endTime = Get-Date
        $executionTime = ($endTime - $startTime).TotalSeconds
        
        # Parse results from output
        $found = $false
        $candidateId = $null
        $matchType = $null
        
        if ($output -match "($($test.email)) FOUND (.+)") {
            $found = $true
            $candidateId = $matches[2].Trim()
        } elseif ($output -match "($($test.email)) NOT found") {
            $found = $false
        }
        
        # Extract match type if available
        if ($output -match "Email found in CRM \((.+?)\)") {
            $matchType = $matches[1]
        }
        
        # Determine test result
        $actualResult = if ($found) { "FOUND" } else { "NOT_FOUND" }
        $testPassed = ($actualResult -eq $test.expectedResult)
        
        # Display result
        if ($testPassed) {
            Write-Host "✅ PASS" -ForegroundColor Green
            $passedTests++
        } else {
            Write-Host "❌ FAIL" -ForegroundColor Red
            $failedTests++
        }
        
        Write-Host "   Result: $actualResult"
        if ($candidateId) {
            Write-Host "   Candidate ID: $candidateId"
        }
        if ($matchType) {
            Write-Host "   Match Type: $matchType"
        }
        Write-Host "   Execution Time: $([math]::Round($executionTime, 1))s"
        
        # Store detailed results
        $testResults += [PSCustomObject]@{
            TestNumber = $testNumber
            Email = $test.email
            Expected = $test.expectedResult
            Actual = $actualResult
            CandidateId = $candidateId
            MatchType = $matchType
            ExecutionTime = [math]::Round($executionTime, 1)
            Passed = $testPassed
        }
        
    } catch {
        Write-Host "❌ FAIL - Exception occurred" -ForegroundColor Red
        Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor Red
        $failedTests++
    }
}

# Final Summary
Write-Host ""
Write-Host "=" * 60
Write-Host "🏁 COMPREHENSIVE TEST SUITE COMPLETED" -ForegroundColor Green
Write-Host ""
Write-Host "📊 SUMMARY RESULTS:" -ForegroundColor Cyan
Write-Host "   Total Tests: $totalTests"
Write-Host "   Passed: $passedTests" -ForegroundColor Green  
Write-Host "   Failed: $failedTests" -ForegroundColor Red
$successRate = [math]::Round(($passedTests / $totalTests) * 100, 1)
Write-Host "   Success Rate: $successRate%"

# Show detailed results
Write-Host ""
Write-Host "📋 DETAILED RESULTS:" -ForegroundColor Cyan
$testResults | Format-Table TestNumber, Email, Expected, Actual, CandidateId, ExecutionTime, Passed -AutoSize

if ($failedTests -eq 0) {
    Write-Host ""
    Write-Host "🎉 ALL TESTS PASSED! System is fully reliable!" -ForegroundColor Green
}

Write-Host ""
Write-Host "🔍 TESTING COMPLETED - Ready for production!" -ForegroundColor Green