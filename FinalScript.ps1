##Header

# Définir les couleurs
$green = "Green"
$magenta = "Magenta"

Write-Host "Bravo, tu viens d'exécuter ton premier script chez" -ForegroundColor $green

Write-Host @"
   _____ ____  _____          
  / ____/ __ \|  __ \   /\    
 | |   | |  | | |  | | /  \   
 | |   | |  | | |  | |/ /\ \  
 | |___| |__| | |__| / ____ \ 
  \_____\____/|_____/_/    \_\
"@ -ForegroundColor $green

Write-Host ""
Write-Host "Le premier d'une longue série !!!" -ForegroundColor $magenta


##Script d'installation Choco

Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

##Script d'installation VsCode

Write-Host "Installation de Visual Studio Code..."
choco install vscode -y
Start-Sleep -Seconds 5

# Installer l'extension C/C++ de Microsoft
code --install-extension ms-vscode.cpptools

##Script d'installation Git

# Installer Chocolatey si ce n'est pas déjà fait
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

# Installer Git
choco install git -y

# Installer github-desktop : https://github.com/apps/desktop
choco install github-desktop

Write-Output "Git (incluant Git Bash) et GitHub Desktop ont été installés avec succès."

##Script d'installation MinGw

choco install mingw -y

# Ajouter MinGW au PATH
$mingwPath = "C:\tools\mingw64\bin"
$envPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
if ($envPath -notlike "*$mingwPath*") {
    [Environment]::SetEnvironmentVariable("Path", $envPath + ";" + $mingwPath, "Machine")
}

Write-Output "GCC a été installé avec succès."

##Script d'installation docker 

Write-Output "Installation de Docker Desktop..."
choco install docker-desktop -y

# Démarrer Docker Desktop
Write-Output "Lancement de Docker Desktop..."
Start-Process -FilePath "C:\Program Files\Docker\Docker\Docker Desktop.exe"

# Attendre que Docker Desktop soit prêt
Write-Output "Attente que Docker Desktop soit prêt..."
$dockerReady = $false
while (-not $dockerReady) {
    try {
        docker system info | Out-Null
        $dockerReady = $true
    } catch {
        Start-Sleep -Seconds 1
    }
}

Write-Output "Docker Desktop est prêt à l'emploi."

##Script d'installation SDK

# Installer OpenJDK (JDK) : https://openjdk.org/
choco install OpenJDK -y

# Installer Node.js (et npm) : https://nodejs.org/en
choco install nodejs-lts -y

##Script d'installation PHP

Write-Output "Lancement d'une image PHP avec la dernière version..."
docker run -d --name php-container -p 8080:80 php:latest

# Vérifier que le conteneur est bien démarré
Write-Output "Vérification que le conteneur est bien démarré..."
$containerRunning = docker ps | Select-String "php-container"
if ($containerRunning) {
    Write-Output "Le conteneur PHP est bien démarré."
} else {
    Write-Output "Échec du démarrage du conteneur PHP."
    exit 1
}

Write-Output "L'image PHP avec la dernière version a été lancée avec succès."

# Arrêter le conteneur
Write-Output "Arrêt du conteneur PHP..."
docker stop php-container

# Arrêter Docker Desktop
Write-Output "Arrêt de Docker Desktop..."
Stop-Process -Name "Docker Desktop" -ErrorAction SilentlyContinue

Write-Output "Le conteneur PHP et Docker Desktop ont été arrêtés avec succès."

# Installer IDE pour PHP
choco install phpstorm -y

# Ouvrir PhpStorm et créez vous un compte Jetbrains
phpstorm



