#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

echo ""
echo "  ========================================"
echo "   Angy Latina - Pubblica sito (GitHub Pages)"
echo "  ========================================"
echo ""

if [[ ! -f index.html ]]; then
  echo "ERRORE: index.html non trovato. Esegui dalla cartella angylatina-site."
  exit 1
fi

if [[ ! -f content.json ]]; then
  echo "ATTENZIONE: content.json mancante."
  echo ""
  echo "  1. Apri https://angylatina.it (o index.html)"
  echo "  2. Area personale -> Pubblica sul sito"
  echo "  3. Salva il file qui come content.json"
  echo ""
  read -r -p "Hai messo content.json qui? [Invio continua / Ctrl+C esci] "
  if [[ ! -f content.json ]]; then
    echo "Ancora assente. Copia content.json e rilancia ./pubblica.sh"
    exit 1
  fi
fi

echo "OK: content.json presente."
echo ""

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  if git remote get-url origin >/dev/null 2>&1; then
    echo "Git: commit e push su GitHub (Pages si aggiorna in 1-2 min)..."
    git add content.json assets/ index.html 2>/dev/null || true
    git add -u
    if git diff --staged --quiet; then
      echo "Nessuna modifica da committare."
    else
      git commit -m "Pubblica contenuti sito Angy Latina"
    fi
    git push
    echo ""
    echo "Fatto. Controlla Actions su GitHub se il deploy non parte."
  else
    echo "Repo git senza remote. Vedi DEPLOY-GITHUB.md (git remote add origin ...)."
  fi
else
  echo "Cartella non e un repo git. Vedi DEPLOY-GITHUB.md per init e push."
fi

echo ""
