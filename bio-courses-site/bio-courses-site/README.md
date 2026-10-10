# Bioinformatics & Statistics Courses

Two hands-on, open courses for biologists learning to analyse their own data in **R**:

- **R for Bioinformatics** — 5 parts, 17 modules: the R mindset → files & objects → the tidyverse → Bioconductor → writing your own package.
- **Statistics for Biologists** — 6 parts, 16 modules: study design → probability → hypothesis testing → linear models → GLMs & mixed models → multivariate methods, plus a *Choosing the Right Test* decision guide.

Built as a [Quarto](https://quarto.org) website and published free on GitHub Pages.

## Repository layout

```
.
├── _quarto.yml                  # site config (nav, theme)
├── index.qmd                    # landing page
├── r-for-bioinformatics/        # course 1: theory + code pages (.qmd)
├── statistics-for-biologists/   # course 2: theory + code pages (.qmd)
├── downloads/                   # the raw exercises/solutions .R scripts
├── data/                        # example datasets used throughout
├── styles.css
└── .github/workflows/publish.yml  # auto-render & deploy to Pages
```

## Preview it locally

1. Install [Quarto](https://quarto.org/docs/get-started/) (and R + RStudio to *run* the code).
2. From this folder:

   ```bash
   quarto preview      # live local preview in your browser
   quarto render       # build the static site into _site/
   ```

The site renders **without R**, because code is displayed (not executed) — so anyone can build it. Learners run the `.R` scripts themselves in RStudio.

## Publish it free on GitHub Pages (one-time setup)

1. Create a new GitHub repo (e.g. `bio-courses`) and push this folder:

   ```bash
   git init
   git add .
   git commit -m "Initial course site"
   git branch -M main
   git remote add origin https://github.com/USERNAME/bio-courses.git
   git push -u origin main
   ```

2. On GitHub: **Settings → Pages → Build and deployment → Source: GitHub Actions**.
3. That's it. The included workflow (`.github/workflows/publish.yml`) renders the site and deploys it on every push to `main`. Your site appears at:

   `https://USERNAME.github.io/bio-courses/`

4. Edit `index.qmd` and this README to replace `USERNAME` with your GitHub handle, and set your name in `LICENSE`.

## Updating content

- Edit the `.qmd` files (theory) or the `.R` files in `downloads/` (then update the matching code page) and push — the site rebuilds automatically.
- The `.qmd` theory pages were generated from the original Word documents; edit them directly from now on.

## Licence

- **Course content** (text, exercises): [CC BY 4.0](LICENSE-content.md) — reuse with attribution.
- **Code samples**: [MIT](LICENSE).
