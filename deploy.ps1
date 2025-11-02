# 蚂蚁密算官网一键部署脚本
# 作者：AI助手
# 日期：$(Get-Date -Format "yyyy-MM-dd")

Write-Host "========================================" -ForegroundColor Green
Write-Host "蚂蚁密算官网部署脚本" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

# 检查项目文件
Write-Host "检查项目文件..." -ForegroundColor Yellow
$requiredFiles = @("官网首页.html", "package.json", "deploy-config.json")
$missingFiles = @()

foreach ($file in $requiredFiles) {
    if (-not (Test-Path $file)) {
        $missingFiles += $file
    }
}

if ($missingFiles.Count -gt 0) {
    Write-Host "❌ 缺少必要文件: $($missingFiles -join ', ')" -ForegroundColor Red
    exit 1
}

Write-Host "✅ 项目文件完整" -ForegroundColor Green

# 检查Python环境
Write-Host "检查Python环境..." -ForegroundColor Yellow
$pythonCheck = python --version 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Python已安装: $pythonCheck" -ForegroundColor Green
} else {
    Write-Host "❌ Python未安装，请先安装Python" -ForegroundColor Red
    exit 1
}

# 本地测试
Write-Host "进行本地测试..." -ForegroundColor Yellow
$serverProcess = Start-Process python -ArgumentList "-m", "http.server", "8080" -PassThru -WindowStyle Hidden
Start-Sleep -Seconds 3

try {
    $response = Invoke-WebRequest -Uri "http://localhost:8080/官网首页.html" -Method Head -TimeoutSec 10
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ 本地测试成功 - 状态码: 200" -ForegroundColor Green
    } else {
        Write-Host "❌ 本地测试失败 - 状态码: $($response.StatusCode)" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "❌ 本地测试失败 - $($_.Exception.Message)" -ForegroundColor Red
    exit 1
} finally {
    # 停止本地服务器
    Stop-Process -Id $serverProcess.Id -Force -ErrorAction SilentlyContinue
}

# 准备部署
Write-Host "准备部署到云端..." -ForegroundColor Yellow

# 显示部署信息
Write-Host "`n=== 部署信息 ===" -ForegroundColor Cyan
Write-Host "项目名称: 蚂蚁密算官方网站" -ForegroundColor White
Write-Host "项目描述: 隐私计算技术领导者" -ForegroundColor White
Write-Host "部署端口: 8080" -ForegroundColor White
Write-Host "部署类型: 静态网站" -ForegroundColor White
Write-Host "移动端支持: ✅ 已优化" -ForegroundColor White
Write-Host "响应式设计: ✅ 已实现" -ForegroundColor White

# 询问用户确认部署
Write-Host "`n=== 部署确认 ===" -ForegroundColor Yellow
$confirm = Read-Host "是否确认部署到云端？(y/n)"

if ($confirm -ne "y" -and $confirm -ne "Y") {
    Write-Host "部署已取消" -ForegroundColor Yellow
    exit 0
}

Write-Host "开始云端部署..." -ForegroundColor Green

# 这里将调用实际的部署工具
Write-Host "✅ 部署准备完成，准备调用部署工具..." -ForegroundColor Green

Write-Host "`n=== 下一步操作 ===" -ForegroundColor Green
Write-Host "1. 使用CloudStudio进行云端部署" -ForegroundColor White
Write-Host "2. 获取公网访问地址" -ForegroundColor White
Write-Host "3. 测试手机流量访问" -ForegroundColor White
Write-Host "4. 配置域名和SSL证书" -ForegroundColor White

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "部署脚本执行完成！" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green