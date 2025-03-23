# Check Database Installations Script
# This script checks for various database installations and their versions

function Write-Header {
    param([string]$title)
    Write-Host "`n=== $title ===" -ForegroundColor Cyan
}

function Test-Command {
    param([string]$command)
    try {
        if (Get-Command $command -ErrorAction Stop) { return $true }
    }
    catch { return $false }
}

# MySQL Check
Write-Header "MySQL"
if (Test-Command "mysql") {
    $version = mysql --version
    Write-Host "✓ MySQL is installed: $version" -ForegroundColor Green
} else {
    Write-Host "✗ MySQL is not installed" -ForegroundColor Red
    Write-Host "Installation Guide:" -ForegroundColor Yellow
    Write-Host "1. Download MySQL Installer from: https://dev.mysql.com/downloads/installer/"
    Write-Host "2. Run installer as administrator"
    Write-Host "3. Choose 'Server only' or 'Custom' installation"
    Write-Host "4. Follow setup wizard for enterprise configuration"
    Write-Host "5. Recommended settings:"
    Write-Host "   - Use Legacy Authentication Method"
    Write-Host "   - Set root password"
    Write-Host "   - Configure as Windows Service"
    Write-Host "   - Add MySQL to System PATH"
}

# PostgreSQL Check
Write-Header "PostgreSQL"
if (Test-Command "psql") {
    $version = psql --version
    Write-Host "✓ PostgreSQL is installed: $version" -ForegroundColor Green
} else {
    Write-Host "✗ PostgreSQL is not installed" -ForegroundColor Red
    Write-Host "Installation Guide:" -ForegroundColor Yellow
    Write-Host "1. Download installer from: https://www.postgresql.org/download/windows/"
    Write-Host "2. Run installer as administrator"
    Write-Host "3. Recommended settings:"
    Write-Host "   - Install PostgreSQL Server"
    Write-Host "   - Install pgAdmin 4"
    Write-Host "   - Set superuser password"
    Write-Host "   - Set port (default: 5432)"
    Write-Host "   - Set locale"
}

# MongoDB Check
Write-Header "MongoDB"
if (Test-Command "mongod") {
    $version = mongod --version | Select-String "db version"
    Write-Host "✓ MongoDB is installed: $version" -ForegroundColor Green
} else {
    Write-Host "✗ MongoDB is not installed" -ForegroundColor Red
    Write-Host "Installation Guide:" -ForegroundColor Yellow
    Write-Host "1. Download MongoDB Community Server: https://www.mongodb.com/try/download/community"
    Write-Host "2. Run installer as administrator"
    Write-Host "3. Choose 'Complete' setup type"
    Write-Host "4. Install MongoDB Compass (GUI)"
    Write-Host "5. Configure MongoDB as a Windows Service"
    Write-Host "6. Set data directory (default: C:\Program Files\MongoDB\Server\[version]\data)"
    Write-Host "7. Set log directory (default: C:\Program Files\MongoDB\Server\[version]\log)"
}

# SQL Server Check
Write-Header "SQL Server"
if (Test-Command "sqlcmd") {
    Write-Host "✓ SQL Server Command Line Tools are installed" -ForegroundColor Green
    try {
        $instance = sqlcmd -Q "SELECT @@VERSION" -h-1
        Write-Host "SQL Server Instance: $instance" -ForegroundColor Green
    } catch {
        Write-Host "Note: SQL Server tools found but could not connect to an instance" -ForegroundColor Yellow
    }
} else {
    Write-Host "✗ SQL Server Command Line Tools not found" -ForegroundColor Red
    Write-Host "Installation Guide:" -ForegroundColor Yellow
    Write-Host "1. Download SQL Server Developer/Express: https://www.microsoft.com/en-us/sql-server/sql-server-downloads"
    Write-Host "2. Run installer as administrator"
    Write-Host "3. Choose 'Basic' or 'Custom' installation"
    Write-Host "4. Install SQL Server Management Studio (SSMS)"
    Write-Host "5. Configure:"
    Write-Host "   - Authentication mode (Windows/Mixed)"
    Write-Host "   - Data directories"
    Write-Host "   - Memory settings"
    Write-Host "   - Network protocols"
}

Write-Host "`nScript completed. Review any missing installations and follow the guides provided." -ForegroundColor Cyan
