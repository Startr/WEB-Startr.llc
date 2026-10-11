# startr.llc TODOs

## In Progress

- [ ] **Publish the Startr LLC company page** (2026-09-29): the apex still serves the older draft (contact `info@startr.cloud`) from Pages project `web-startr-llc`; `www.startr.llc` returns 522 (checked 2026-10-11).
  - [x] Draft `public/index.html` in the plante.somma.consulting style; `make check` green.
  - [x] Link previews and icons (2026-09-29): 1200x630 social card, favicons from an S monogram (the wordmark is unreadable below 48px), Apple, Android and maskable icons, web manifest. Sources in `design/`.
  - [x] Create the GitHub repo and push (2026-09-29): `Startr/WEB-Startr.llc`, public, git-flow with `develop` as the default branch and `master` for releases.
  - [x] Mail for every @startr.llc address into the shared `hello@sage.is` inbox (2026-10-11); Resend probe `startr-llc-20261011T081726Z` to `info@startr.llc` arrived. Recipe: OPS-Sage `docs/runbooks/mail.md`, Day 6.
    - [x] Email Routing on; Cloudflare wrote and locked MX `route1/2/3.mx.cloudflare.net` and DKIM `cf2024-1._domainkey`.
    - [x] SPF `v=spf1 include:_spf.mx.cloudflare.net -all`, one record beside the google-site-verification TXT.
    - [x] `_dmarc`: `p=quarantine; adkim=s; rua=mailto:dmarc@sage.is`; sage.is authorises the reports with `startr.llc._report._dmarc.sage.is TXT "v=DMARC1"`.
    - [x] Catch-all to Worker `trellis-inbound-mail`, which files recipients it has no login for into hello@ (`via=catchall`).
  - [x] The Pages project exists (found 2026-10-09): `web-startr-llc`, direct upload (no git source), production branch `main`, domains `web-startr-llc.pages.dev` and `startr.llc`. No `startr-llc` project is needed.
  - [x] The old HTTP redirect rule is gone (2026-10-09): no page rules, no Single Redirect ruleset, Always Use HTTPS off; the HTTP 301 comes from Pages.
  - [x] [WE] Point `PAGES_PROJECT` in the Makefile at `web-startr-llc` (2026-10-11).
  - [x] Production branch `master` (2026-10-11): the release record, as in every Startr repo; `develop` is the default branch and its deploys are previews. Set on `web-startr-llc` through the API (was `main`).
  - [ ] [MANUALLY] Cut a release so `master` carries the page: `make minor_release`, then `make release_finish` (git-flow-next).
  - [ ] [WE] `make deploy` from the `master` checkout, on Alexander's word, with `bw:cloudflare-startr-llc` through `sage-secret`.
  - [ ] [WE] Attach `www.startr.llc` to `web-startr-llc` (fixes the 522); the www-to-apex redirect then needs a Single Redirect rule.
  - [ ] [WE] Verify <https://startr.llc> serves the page, and `www` redirects to the apex.
  - [ ] [WE] After deploy, check the preview in a link debugger (opengraph.xyz or a Slack paste).
  - [ ] [MANUALLY] Swap in a larger logo master when one exists; the 512px icons are upscaled from a 400px source.

## TODO

- [ ] **Make startr.llc the canonical legal home**: the page links the policies on startr.cloud. Moving them needs founder review of the "doing business as startr.cloud" wording.
- [ ] **Fix startr.cloud's footer**: `/privacy` and `/cookies` return 404 (checked 2026-10-09).
  - [ ] [WE] Point the footer at `/policies/privacy/`, `/policies/terms/`, `/policies/refund/` and `/policies/security/` (each 200).
  - [ ] [MANUALLY] Approve a cookies policy: `/policies/cookies/` is 404 as well, so none exists; the `/policies/` index is 404 too.

## Backlog

- [ ] **Refresh startr.cloud's look and copy**: its meta description, inherited from the WEB-11ty starter, still describes "the best of Canada".
- [ ] **Pin startr.style** once a versioned URL exists; the page loads the unversioned stylesheet.

## Done

- [x] **Decide the public contact address**: `info@startr.llc` (2026-09-29).
