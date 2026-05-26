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
  echo Push fallito. Controlla connessione e permessi GitHub.
)

:FINE
echo.
pause
endlocal
