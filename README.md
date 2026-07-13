# Portfolio — a 2D spatial developer portfolio

A bold, type-forward developer portfolio built around one signature mechanic: a **unified 2D spatial
camera-journey**. You swipe / scroll and the camera flies through a snaking 2D world of 8 scenes —
intro, about, four case studies, a toolbelt, and contact. No page reloads, no scroll bars: one gesture
snaps you to the next stop.

> **Note:** the content in this repo is placeholder (`Alex Chen`). It's a finished, production-hardened
> template — swap in real content to make it yours.

## Highlights

- **Signature interaction** — a GSAP-driven camera that translates a single composited `#world` layer
  along a Catmull-Rom path; one gesture = one scene, with snap-to-center.
- **Fast & solid** — Lighthouse **Performance ~97–100**, **Accessibility 100**, **SEO 100**, **CLS ≤0.1**,
  LCP ~1–2s, TBT 0. Critical CSS inlined, `defer.css` async, self-hosted subset variable fonts
  (`font-display: optional`), gzip/immutable caching.
- **Smooth on mobile** — the pan is kept cheap on weak GPUs: only the on-screen scenes render
  (`content-visibility`), the world paints nothing (per-scene grid), and heavy paint is stripped
  mid-flight — so a real 2D journey stays fluid at DPR 3.
- **Graceful degradation** — `prefers-reduced-motion` → a readable vertical layout; full keyboard
  navigation with visible focus; the semantic content is server-rendered and scrolls with JavaScript
  disabled; a one-tap **List view** for recruiters.
- **SEO-ready** — JSON-LD `@graph` (Person / ProfilePage / WebSite / BreadcrumbList), Open Graph +
  Twitter cards with a 1200×630 image, `sitemap.xml`, `robots.txt`, web manifest, favicons.

## Stack

Vanilla **HTML / CSS / JS** + **GSAP** (animation) — no framework, no build step. Self-hosted
Clash Display / General Sans / Space Mono variable fonts. Served by **nginx** in Docker.

## Run it

```bash
# with Docker (serves on http://localhost:8095)
docker compose up -d --build

# or any static server — the site is just static files
cd site && python3 -m http.server 8000
```

## Layout

```
site/            # the deliverable — static files, no build
  index.html     # single self-contained page (inline critical CSS + JS)
  defer.css      # non-critical CSS, loaded async
  gsap.min.js    # animation engine (vendored)
  *.woff2        # subset variable fonts
  og-image.png, favicons, sitemap.xml, robots.txt, site.webmanifest
Dockerfile         # nginx:alpine + gzip precompress
nginx.conf         # gzip, immutable caching, correct content-types
docker-compose.yml # one-command local run
```

## Make it yours

1. Replace the name, role, and the four case studies (problem → result + metric + link) in `index.html`.
2. Point the social links (GitHub / LinkedIn / email / résumé) at your real profiles.
3. Set your production domain in the canonical / OG / JSON-LD URLs + `sitemap.xml` / `robots.txt`,
   and serve over HTTPS.
