# Deploy Script for my_phc_helper_web
# Run this in PowerShell

Write-Host "🚧 Building Flutter Web App..." -ForegroundColor Cyan
flutter build web --release --base-href "/my_phc_helper_web/"

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Build failed." -ForegroundColor Red
    exit
}

Write-Host "📂 Navigating to build/web..." -ForegroundColor Cyan
cd build/web

Write-Host "git 初始化 in build folder..." -ForegroundColor Cyan
git init
git add .
git commit -m "Deploy from my_phc_helper source"

# Add the specific remote for the HOSTING repository
Write-Host "🔗 Adding remote..." -ForegroundColor Cyan
git remote add origin https://github.com/drshravan/my_phc_helper_web.git

# Force push to gh-pages branch
Write-Host "🚀 Deploying to GitHub Pages..." -ForegroundColor Cyan
git branch -M gh-pages
git push -f origin gh-pages

Write-Host "✅ Deployment Complete!" -ForegroundColor Green
Write-Host "🌍 Live at: https://drshravan.github.io/my_phc_helper_web/" -ForegroundColor Green

# Return to root
cd ../..
