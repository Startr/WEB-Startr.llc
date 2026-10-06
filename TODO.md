# startr.llc TODOs

## In Progress

- [ ] **Publish the Startr LLC company page** (2026-09-29): the apex answers 200 over HTTPS with an older draft (contact info@startr.cloud, the logo as og:image); plain HTTP 301s to it; www.startr.llc returns 522 (checked 2026-10-06).
  - [x] Draft `public/index.html` in the plante.somma.consulting style; `make check` green.
  - [x] Link previews and icons (2026-09-29): 1200x630 social card, favicons from an S monogram (the wordmark is unreadable below 48px), Apple, Android and maskable icons, web manifest. Sources in `design/`.
  - [ ] [MANUALLY] Send a test email to `info@startr.llc` once mail is routed. The zone (Cloudflare DNS) has no MX, SPF or DMARC yet (2026-10-06); the plan routes every @startr.llc address into the shared hello@sage.is inbox via Email Routing and the Trellis Worker, waiting on the API token gaining the startr.llc zone.
  - [ ] After deploy, check the preview in a link debugger (opengraph.xyz or a Slack paste).
  - [ ] Swap in a larger logo master when one exists; the 512px icons are upscaled from a 400px source.
  - [x] Create the GitHub repo and push (2026-09-29): `Startr/WEB-Startr.llc`, public, git-flow with `develop` as the default branch and `master` for releases.
  - [ ] [MANUALLY] Cloudflare: create Pages project `startr-llc`, add custom domains `startr.llc` and `www.startr.llc`, remove the old HTTP redirect rule.
  - [ ] Verify <https://startr.llc> serves the page, and `www` redirects to the apex.

## TODO

- [x] **Decide the public contact address**: `info@startr.llc` (2026-09-29).
- [ ] **Make startr.llc the canonical legal home**: the page links the policies on startr.cloud. Moving them needs founder review of the "doing business as startr.cloud" wording.
- [ ] **Fix startr.cloud's footer**: `/privacy` and `/cookies` return 404; the live policies sit under `/policies/`.

## Backlog

- [ ] **Refresh startr.cloud's look and copy**: its meta description, inherited from the WEB-11ty starter, still describes "the best of Canada".
- [ ] **Pin startr.style** once a versioned URL exists; the page loads the unversioned stylesheet.

## Done
