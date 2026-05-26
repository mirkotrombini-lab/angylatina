# Angy Latina — pubblicazione su GitHub Pages

Sito statico: niente crediti Netlify. Il sito live viene da **GitHub Pages** con dominio **angylatina.it**.

## Repository consigliato

- Organizzazione: `mirkotrombini-lab` (come `ladocrisponde-dev`)
- Nome repo: **`angylatina`** oppure `angylatina-site`
- Branch: **`main`**

## Prima pubblicazione (una tantum)

### 1. Crea il repo su GitHub

1. Vai su https://github.com/new
2. Owner: `mirkotrombini-lab`
3. Nome: `angylatina`
4. **Public** (richiesto per Pages gratis su org private a volte limitato — repo public e gratis)
5. Non aggiungere README/licenza se carichi da locale (evita conflitti)

### 2. Carica il codice da questo PC

```bash
cd /home/nexora/projects/angylatina-site
git init
git branch -M main
git add index.html content.json assets/ CNAME .nojekyll .github .gitignore pubblica.sh pubblica.bat DEPLOY-GITHUB.md
git commit -m "Sito Angy Latina: GitHub Pages, content.json, assets"
git remote add origin git@github.com:mirkotrombini-lab/angylatina.git
git push -u origin main
```

(Sostituisci `angylatina` se hai scelto un altro nome repo.)

### 3. Attiva GitHub Pages (senza Actions)

Il sito e statico (`index.html` in root). **Non serve un workflow** — evita errori Actions del tipo "Failed to download archive".

1. Repo → **Settings** → **Pages**
2. **Build and deployment** → Source: **Deploy from a branch**
3. Branch: **`main`** · cartella **`/ (root)`**
4. **Save**
5. Attendi 1–3 minuti; ricarica la pagina Settings → compare l’URL del sito

URL temporaneo: `https://mirkotrombini-lab.github.io/angylatina/`

Se in **Actions** vedi run falliti vecchi, ignorali oppure disabilita Actions nel repo (Settings → Actions → Disable).

**Se in futuro vuoi usare Actions** e falliscono tutte con "codeload.github.com": nell’organizzazione `mirkotrombini-lab` vai in **Settings → Actions → General** e consenti le GitHub Actions (es. "Allow all actions").

### 4. Dominio angylatina.it

Nel repo c'e gia il file **`CNAME`** con `angylatina.it`.

Nel pannello DNS del dominio (dove compri angylatina.it):

**Opzione A — dominio principale (apex)**

| Tipo | Nome | Valore |
|------|------|--------|
| A | `@` | `185.199.108.153` |
| A | `@` | `185.199.109.153` |
| A | `@` | `185.199.110.153` |
| A | `@` | `185.199.111.153` |

**Opzione B — www**

| Tipo | Nome | Valore |
|------|------|--------|
| CNAME | `www` | `mirkotrombini-lab.github.io` |

Poi in GitHub: **Settings → Pages → Custom domain** → `angylatina.it` → attiva **Enforce HTTPS**.

Verifica IP aggiornati: https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site

## Aggiornamenti contenuti (flusso abituale)

1. Modifica in **Area personale** su `https://angylatina.it` (o in locale aprendo `index.html`)
2. **Pubblica sul sito** → scarica `content.json`
3. Sostituisci `content.json` in questa cartella
4. Se hai aggiunto foto in `assets/gallery/`, committale anche quelle
5. Push:

```bash
cd /home/nexora/projects/angylatina-site
git add content.json assets/
git commit -m "Aggiorna contenuti sito"
git push
```

GitHub Actions ridistribuisce in 1–2 minuti.

## Rapporto con Nexora (195.231.87.149)

| Cosa | Dove |
|------|------|
| **angylatina.it** | GitHub Pages (gratis, repo `mirkotrombini-lab/angylatina`) |
| **ladocrisponde / dashboard** | Server LIVE `195.231.87.149` porta **8080** (nexora-dev) |

Non serve passare angylatina dal server 195: il DNS di **angylatina.it** punta a GitHub.

Se in passato usavi Netlify, rimuovi o aggiorna i record DNS che puntavano a Netlify, altrimenti il dominio non segue GitHub.

## File grossi

- `assets/hero-video.mp4` (~30 MB): ok per GitHub (limite 100 MB per file)
- Evita di mettere decine di foto grandi **solo** in `content.json` come base64: usa `assets/gallery/nome.jpg` + URL nell'admin

## Problemi comuni

| Problema | Soluzione |
|----------|-----------|
| Pages non parte | Settings → Pages → source = **GitHub Actions** |
| 404 su video hero | File deve essere `assets/hero-video.mp4` (minuscolo) |
| Dominio non funziona | Controlla DNS + attendi propagazione (fino a 48h) |
| Sito vecchio Netlify | Cambia DNS verso GitHub |
