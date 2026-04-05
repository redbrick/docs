---
id: atlas
aliases:
  - Atlas
tags:
  - webgroup
  - website
title: Atlas
---

# Atlas (Redbrick Website)

Atlas is Redbrick’s static website, built with [Eleventy (11ty)](https://www.11ty.dev/) and styled with Tailwind CSS + PostCSS. The site output is generated into `dist/` and can be served locally during development, or built into a production container served by Nginx.

## Quick links

- Live site: [https://redbrick.dcu.ie](https://redbrick.dcu.ie)

## Tech stack / tooling

- **Node.js**: `^18.17 || ^20`
- **Package manager**: Yarn (`yarn@4.1.0`, via Corepack)
- **Static site generator**: Eleventy (`@11ty/eleventy`)
- **Templating**: Nunjucks (`.njk`) + Markdown (`.md`) + HTML
- **CSS**: Tailwind CSS + PostCSS (Autoprefixer)
- **Search**: Pagefind
- **Container build/runtime**: multi-stage Docker build (Node build → Nginx runtime)
- **CI/CD**: GitHub Actions (build/publish + deploy)

## Development

Install dependencies:

```bash
corepack enable
yarn
```

Run a dev server:

```bash
yarn dev
```

Build for production (outputs to `dist/`):

```bash
yarn build
```

## Build output

- Eleventy input: `src/site`
- Eleventy output: `dist`

(These are configured in `package.json` under the `eleventy.dir` section.)

## File structure breakdown

> Note: `dist/` is generated at build time and is not committed.

```text
.
├── .github/
│   ├── deploy/
│   │   ├── production.hcl          # Nomad job spec for production deployment
│   │   └── review.hcl              # Nomad job spec for review (branch) deployments
│   └── workflows/
│       ├── build.yml               # Build & publish Docker image to GHCR
│       └── deploy.yml              # Deploy workflow (prod + review environments)
├── eleventy/
│   ├── filters/
│   │   └── slugify.js              # Custom filter(s) for templates
│   ├── parsers/
│   │   └── markdown.js             # Markdown parser configuration
│   ├── plugins/
│   │   ├── git-build.js            # Build metadata from git
│   │   ├── navigation-render.js    # Navigation rendering helper
│   │   └── pagefind.js             # Pagefind integration
│   └── utils/                      # Eleventy utility code (helpers)
├── src/
│   ├── _data/                      # Eleventy data files (global/site data)
│   ├── _includes/                  # Includes/partials used by templates
│   ├── _layouts/                   # Layout templates
│   └── site/                       # Main Eleventy input directory
│       ├── assets/                # Static assets (images, fonts, etc.)
│       ├── index.md                # Homepage content
│       ├── links.md                # Links page content
│       └── 404.md                  # 404 page content
├── .dockerignore
├── .editorconfig
├── .eleventy.js                    # Eleventy config entrypoint
├─  .eleventyignore
├── .gitattributes
├── .gitignore
├── Dockerfile                      # Multi-stage build (Node -> Nginx)
├── nginx.conf                      # Nginx config for serving the built site
├── postcss.config.js               # PostCSS configuration
├── tailwind.config.js              # Tailwind configuration
├── package.json                    # Scripts + dependencies + Eleventy directory config
├── yarn.lock
└── LICENSE
```

## Docker

A multi-stage Docker build is used:

1. **build stage**: installs deps + runs `yarn build` to generate `dist/`
2. **production stage**: serves `dist/` via `nginx`

## Deployments (high-level)

- Docker images are built and published via GitHub Actions.
- Deployments use Nomad job specifications in `.github/deploy/` for:
    - **Production** (`production.hcl`)
    - **Review** per-branch (`review.hcl`)


## Running locally with Docker

To run the site locally in a Docker container (serving the production build via Nginx):
1. Build the Docker image:

```bash
docker build -t redbrick-atlas .
```
2. Run the container:

```bash
docker run -p 8080:80 redbrick-atlas
```
3. Access the site at `http://localhost:8080`.

> [!NOTE]
> When making changes note that the docker image will need to be rebuilt to see the changes reflected in the container.

## Creating a new page
1. Create a new Markdown file in `src/site/` (e.g., `src/site/new-page.md`).
2. Add front matter and content:

```markdown
---
layout: default.njk
---
<main>
    {% include "newpage.njk" %}
</main> 
```

> [!NOTE]
> We advise using a nunjucks include for the page content to keep the Markdown file clean and focused on content, while the layout and styling can be handled in the included Nunjucks template.

3. Create the corresponding Nunjucks template in `src/_includes/` (e.g., `src/_includes/newpage.njk`) and add your HTML content there.
4. Link to the new page from the navigation or other pages as needed.

Navigation links are defined in `src/_data/site.yml` under navigation and global taking a `- text` which is the text shown in the nav and a `link` which is the path to the page (e.g., `/new-page` for `src/site/new-page.md`).

## Outside contributions
- Contributions to the website are always welcome!

> [!WARNING]
> If you want to have the preview deployment for a Pull request the PR must be opened from a branch in the main repository (not a fork) due to GitHub Actions permissions. If you want to open a PR from a fork, you will need to merge it into a branch in the repoisitory and open the PR from there to have the preview deployment. If you are not able to do this, ask a webgroup member to open the PR for you or to merge your PR into a branch in the repository.