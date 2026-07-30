# Scan Skills Script — Tự động quét và phân loại tất cả skills đã cài
# Chạy: powershell -File scan_skills.ps1
# Output: Danh sách skills theo nhóm, in ra console

$globalSkillsPath = Join-Path $env:USERPROFILE ".gemini\config\skills"

if (-not (Test-Path $globalSkillsPath)) {
    Write-Host "ERROR: Skills directory not found at $globalSkillsPath" -ForegroundColor Red
    exit 1
}

$categories = @{
    "BACKEND"      = @()
    "FRONTEND"     = @()
    "SECURITY"     = @()
    "TESTING"      = @()
    "ARCHITECTURE" = @()
    "DEVOPS"       = @()
    "DOCS"         = @()
    "WORKFLOW"     = @()
    "OTHER"        = @()
}

$totalSkillCount = 0
$skillFolders = Get-ChildItem -Path $globalSkillsPath -Directory | Where-Object { $_.Name -notin @("references", "scripts") }

foreach ($folder in $skillFolders) {
    $skillFile = Join-Path $folder.FullName "SKILL.md"
    if (-not (Test-Path $skillFile)) { continue }

    $totalSkillCount++
    $skillName = $folder.Name
    $description = ""

    $headerLines = Get-Content $skillFile -TotalCount 10 -ErrorAction SilentlyContinue
    foreach ($line in $headerLines) {
        if ($line -match "^description:\s*(.+)$") {
            $description = $matches[1].Trim('"').Trim("'")
            break
        }
    }

    # Auto-categorize based on name patterns
    $category = "WORKFLOW"
    if ($skillName -match "api-endpoint|backend-dev|stripe") { $category = "BACKEND" }
    elseif ($skillName -match "frontend|ui|react|nextjs|tailwind|shadcn|brandkit|imagegen|form-cro|seo|enhance_ui|redesign|high-end|image-to-code|web_performance") { $category = "FRONTEND" }
    elseif ($skillName -match "security|auth|pci|sast|secrets|django-access") { $category = "SECURITY" }
    elseif ($skillName -match "test|playwright|k6|qa|locator|flaky|scaffold|screen-reader|browser-automation|browser-testing|webapp-testing|ui_debug") { $category = "TESTING" }
    elseif ($skillName -match "architect|pattern|microservices|event-sourcing|database-design|deprecation|software_architecture|senior-") { $category = "ARCHITECTURE" }
    elseif ($skillName -match "ci-cd|devops|launcher|observability|shipping|open_source|release|performance|dependency") { $category = "DEVOPS" }
    elseif ($skillName -match "doc|diagram|openapi|repo_infographic|requirements|generate_release|list_features|update_docs") { $category = "DOCS" }
    elseif ($skillName -eq "output-skill") { $category = "OTHER" }

    $categories[$category] += [PSCustomObject]@{
        Name        = $skillName
        Description = ($description -split "`n")[0]
        Path        = $skillFile
    }
}

# Output results
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host " SKILL CATALOG — $totalSkillCount skills found" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

foreach ($cat in @("BACKEND", "FRONTEND", "SECURITY", "TESTING", "ARCHITECTURE", "DEVOPS", "DOCS", "WORKFLOW", "OTHER")) {
    $skills = $categories[$cat]
    if ($skills.Count -gt 0) {
        Write-Host "[$cat] ($($skills.Count) skills)" -ForegroundColor Yellow
        foreach ($skill in $skills | Sort-Object Name) {
            $shortDescription = if ($skill.Description.Length -gt 80) { $skill.Description.Substring(0, 77) + "..." } else { $skill.Description }
            Write-Host "  $($skill.Name)" -ForegroundColor Green -NoNewline
            Write-Host " — $shortDescription" -ForegroundColor Gray
        }
        Write-Host ""
    }
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Total: $totalSkillCount skills" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
