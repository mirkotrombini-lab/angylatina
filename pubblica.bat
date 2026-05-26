@echo off
setlocal EnableDelayedExpansion
cd /d "%~dp0" || (
  echo ERRORE: cartella non trovata.
  goto :fine
)

echo.
echo  ========================================
echo   Angy Latina - Pubblica sito v2
echo  ========================================
echo   Cartella: %CD%
echo.

where git >nul 2>&1
if errorlevel 1 (
  echo ERRORE: Git non installato o non nel PATH.
  echo Installa Git for Windows: https://git-scm.com/download/win
  goto :fine
)

if not exist "index.html" (
  echo ERRORE: index.html non trovato. Esegui dalla cartella angylatina-site.
  goto :fine
)

if not exist "content.json" (
  echo ATTENZIONE: content.json mancante.
  echo.
  echo  1. Apri https://angylatina.it
  echo  2. Area personale - accedi
  echo  3. Pubblica sul sito
  echo  4. Salva il file QUI come content.json
  echo.
  set /p OK="Premi INVIO quando content.json e qui, oppure Ctrl+C per uscire..."
  if not exist "content.json" (
    echo Ancora assente.
    goto :fine
  )
)

echo OK: content.json presente.
echo.

git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
  echo ERRORE: questa cartella non e un repository Git.
  echo Leggi DEPLOY-GITHUB.md oppure fai git clone del repo.
  goto :fine
)

git remote get-url origin >nul 2>&1
if errorlevel 1 (
  echo ERRORE: remote origin mancante.
  echo   git remote add origin https://github.com/mirkotrombini-lab/angylatina.git
  goto :fine
)

for /f "delims=" %%u in ('git remote get-url origin 2^>nul') do set "REMOTE=%%u"
echo Remote: !REMOTE!
echo !REMOTE!| findstr /i "git@github.com" >nul
if not errorlevel 1 (
  echo.
  echo Suggerimento: usa HTTPS per evitare errori SSH:
  echo   git remote set-url origin https://github.com/mirkotrombini-lab/angylatina.git
  echo.
)

echo [1/3] Aggiorno il PC dal live ^(git pull^)...
git pull --no-rebase origin main
if errorlevel 1 (
  echo.
  echo PULL fallito ^(conflitto o rete^).
  echo.
  echo Per tenere content.json come sul live:
  echo   git checkout --theirs content.json
  echo   git add content.json
  echo   git commit -m "Allinea content.json al sito live"
  echo.
  echo Per forzare TUTTO uguale al live ^(perdi modifiche locali^):
  echo   git merge --abort
  echo   git fetch origin
  echo   git reset --hard origin/main
  echo.
  goto :fine
)
echo OK: locale aggiornato dal live.
echo.

echo [2/3] Commit modifiche...
git add content.json assets/ index.html 2>nul
git add -u
git diff --staged --quiet
if errorlevel 1 (
  git commit -m "Pubblica contenuti sito Angy Latina"
) else (
  echo Nessuna modifica da committare.
)
echo.

echo [3/3] Push su GitHub...
git push
if errorlevel 1 (
  echo.
  echo PUSH fallito. Se vedi Permission denied publickey:
  echo   git remote set-url origin https://github.com/mirkotrombini-lab/angylatina.git
  echo   git push
  goto :fine
)

echo.
echo FATTO. Il sito live si aggiorna in 1-2 minuti.
echo https://angylatina.it

:fine
echo.
echo --- Fine. Premi un tasto per chiudere ---
pause
endlocal
