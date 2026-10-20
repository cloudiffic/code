# Remove HTML Branding



$HtmlReportPath = "./test-results/Report.html"

if (Test-Path $HtmlReportPath) {
    $html = Get-Content -Path $HtmlReportPath -Raw

    # Regex pattern to remove SVG or IMG tags inside header/logo containers
    # Removes inline <svg> elements containing the logo
    $html = $html -replace '(?s)<svg[^>]*>.*?</svg>', ''
    
    # Alternatively, remove img tags pointing to maester.dev/img/logo.svg
    $html = $html -replace '<img[^>]*src="[^"]*logo\.svg"[^>]*>', ''

    Set-Content -Path $HtmlReportPath -Value $html -Force
}
