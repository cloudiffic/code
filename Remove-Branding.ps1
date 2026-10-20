# Remove HTML Branding

# Define the path to your HTML report
$HtmlReportPath = "./test-results/Report.html"

if (Test-Path $HtmlReportPath) {
    # Read the HTML content
    $htmlContent = Get-Content -Path $HtmlReportPath -Raw

    # Example: Remove or replace specific Maester branding text or elements
    # (Adjust the strings based on the exact text/tags appearing in your HTML output)
    $htmlContent = $htmlContent -replace '<span>Maester</span>', '<span>Your Company Name</span>'
    $htmlContent = $htmlContent -replace '<div class="maester-footer">.*?</div>', ''

    # Save the cleaned HTML back out
    Set-Content -Path $HtmlReportPath -Value $htmlContent -Force
}