# Daily Glow Flutter App Setup Script
# This script copies all generated files to the Flutter project

Write-Host "🌟 Daily Glow Flutter App Setup 🌟" -ForegroundColor Cyan
Write-Host ""

$sourceDir = "e:\Mobile Application Development\daily_glow\flutter_app_setup"
$targetDir = "e:\Mobile Application Development\daily_glow_app\lib"

# Check if source directory exists
if (-not (Test-Path $sourceDir)) {
    Write-Host "❌ Source directory not found: $sourceDir" -ForegroundColor Red
    exit 1
}

# Check if target directory exists
if (-not (Test-Path $targetDir)) {
    Write-Host "❌ Target directory not found: $targetDir" -ForegroundColor Red
    Write-Host "Please make sure the Flutter project exists at: e:\Mobile Application Development\daily_glow_app" -ForegroundColor Yellow
    exit 1
}

Write-Host "📁 Creating directory structure..." -ForegroundColor Yellow

# Create directories
$directories = @(
    "$targetDir\config",
    "$targetDir\providers",
    "$targetDir\screens\auth",
    "$targetDir\screens\home",
    "$targetDir\screens\exercise",
    "$targetDir\screens\water",
    "$targetDir\screens\meal",
    "$targetDir\screens\goals"
)

foreach ($dir in $directories) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Host "  ✓ Created: $dir" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "📋 Copying files..." -ForegroundColor Yellow

# Copy files
$fileMappings = @{
    "main.dart" = "$targetDir\main.dart"
    "config\theme.dart" = "$targetDir\config\theme.dart"
    "providers\user_provider.dart" = "$targetDir\providers\user_provider.dart"
    "screens\auth\login_screen.dart" = "$targetDir\screens\auth\login_screen.dart"
    "screens\auth\register_screen.dart" = "$targetDir\screens\auth\register_screen.dart"
    "screens\home\home_screen.dart" = "$targetDir\screens\home\home_screen.dart"
    "screens\home\dashboard_tab.dart" = "$targetDir\screens\home\dashboard_tab.dart"
    "screens\home\workouts_tab.dart" = "$targetDir\screens\home\workouts_tab.dart"
    "screens\home\progress_tab.dart" = "$targetDir\screens\home\progress_tab.dart"
    "screens\home\profile_tab.dart" = "$targetDir\screens\home\profile_tab.dart"
    "screens\exercise\log_exercise_screen.dart" = "$targetDir\screens\exercise\log_exercise_screen.dart"
    "screens\water\water_intake_screen.dart" = "$targetDir\screens\water\water_intake_screen.dart"
    "screens\meal\log_meal_screen.dart" = "$targetDir\screens\meal\log_meal_screen.dart"
    "screens\goals\goals_screen.dart" = "$targetDir\screens\goals\goals_screen.dart"
}

$successCount = 0
$errorCount = 0

foreach ($mapping in $fileMappings.GetEnumerator()) {
    $source = Join-Path $sourceDir $mapping.Key
    $target = $mapping.Value
    
    if (Test-Path $source) {
        Copy-Item $source $target -Force
        Write-Host "  ✓ Copied: $($mapping.Key)" -ForegroundColor Green
        $successCount++
    } else {
        Write-Host "  ✗ Not found: $($mapping.Key)" -ForegroundColor Red
        $errorCount++
    }
}

Write-Host ""
Write-Host "📊 Summary:" -ForegroundColor Cyan
Write-Host "  ✓ Successfully copied: $successCount files" -ForegroundColor Green
if ($errorCount -gt 0) {
    Write-Host "  ✗ Errors: $errorCount files" -ForegroundColor Red
}

Write-Host ""
Write-Host "⚠️  IMPORTANT: Update pubspec.yaml" -ForegroundColor Yellow
Write-Host "  1. Open: e:\Mobile Application Development\daily_glow_app\pubspec.yaml" -ForegroundColor White
Write-Host "  2. Add dependencies from: flutter_app_setup\pubspec_additions.yaml" -ForegroundColor White
Write-Host "  3. Run: flutter pub get" -ForegroundColor White

Write-Host ""
Write-Host "🚀 Next Steps:" -ForegroundColor Cyan
Write-Host "  1. Update pubspec.yaml with dependencies" -ForegroundColor White
Write-Host "  2. Run: cd 'e:\Mobile Application Development\daily_glow_app'" -ForegroundColor White
Write-Host "  3. Run: flutter pub get" -ForegroundColor White
Write-Host "  4. Run: flutter run" -ForegroundColor White

Write-Host ""
Write-Host "✨ Setup complete! Your app is ready to run! ✨" -ForegroundColor Green
Write-Host ""

# Ask if user wants to open pubspec files
$response = Read-Host "Would you like to open the pubspec files now? (Y/N)"
if ($response -eq 'Y' -or $response -eq 'y') {
    Start-Process notepad "$sourceDir\pubspec_additions.yaml"
    Start-Process notepad "e:\Mobile Application Development\daily_glow_app\pubspec.yaml"
    Write-Host "📝 Opened pubspec files in Notepad" -ForegroundColor Green
}
