@echo off
chcp 65001 >nul
setlocal
cd /d "%~dp0"

echo.
echo  ========================================
echo   Angy Latina - Pubblica sito (GitHub Pages)
echo  ========================================
echo.

if not exist "index.html" (
  echo ERRORE: index.html non trovato. Esegui questo file dalla cartella angylatina-site.
  pause
  exit /b 1
)

if not exist "content.json" (
  echo ATTENZIONE: content.json non trovato in questa cartella.
  echo.
  echo  1. Apri https://angylatina.it  (o index.html nel browser)
  echo  2. Area personale - accedi
  echo  3. Clicca "Pubblica sul sito"
  echo  4. Salva il file scaricato QUI come content.json
  echo.
  set /p OK="Hai messo content.json qui? Premi INVIO per continuare o Ctrl+C per uscire..."
  if not exist "content.json" (
    echo Ancora assente. Copia content.json e rilancia pubblica.bat
    pause
    exit /b 1
  )
)

echo OK: content.json presente.
echo.

git rev-parse --is-inside-work-tree >nul 2>&1
if %errorlevel% neq 0 (
  echo Cartella non e un repo git. Leggi DEPLOY-GITHUB.md per init e push.
  goto FINE
)

git remote get-url origin >nul 2>&1
if %errorlevel% neq 0 (
  echo Repo git senza remote. Leggi DEPLOY-GITHUB.md ^(git remote add origin ...^).
  goto FINE
)

echo Git: commit e push su GitHub...
git add content.json assets/ index.html 2>nul
git add -u
git diff --staged --quiet
if %errorlevel%==0 (
  echo Nessuna modifica da committare.
) else (
  git commit -m "Pubblica contenuti sito Angy Latina"
)
git push
if %errorlevel%==0 (
  echo.
  echo Fatto. GitHub Pages si aggiorna in 1-2 minuti.
) else (
  echo.
  echo Push fallito.
  git remote get-url origin 2>nul | findstr /i "git@github.com" >nul
  if %errorlevel%==0 (
    echo.
    echo  Causa probabile: SSH non configurato su questo PC ^(Permission denied publickey^).
    echo.
    echo  Soluzione A - HTTPS ^(piu semplice su Windows^):
    echo    git remote set-url origin https://github.com/mirkotrombini-lab/angylatina.git
    echo    git push
    echo    ^(usa login GitHub o Personal Access Token quando richiesto^)
    echo.
    echo  Soluzione B - Chiave SSH:
    echo    1. ssh-keygen -t ed25519 -C "tua-email"
    echo    2. Aggiungi la chiave pubblica su GitHub - Settings - SSH keys
    echo    3. Rilancia pubblica.bat
  ) else (
    echo Controlla connessione, remote origin e permessi sul repo mirkotrombini-lab/angylatina.
  )
)

:FINE
echo.
pause
endlocal
